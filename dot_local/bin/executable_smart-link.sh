#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
USE_SUDO=0
DEBUG=0
LOG_FILE="${SMART_LINK_LOG:-/tmp/smart-link.log}"

for arg in "$@"; do
	if [[ "$arg" == "--dry-run" ]]; then
		DRY_RUN=1
	fi
	if [[ "$arg" == "--debug" ]]; then
		DEBUG=1
	fi
done

log() {
	if [[ "$DEBUG" -eq 1 ]]; then
		printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG_FILE"
	fi
}

if [[ "$DEBUG" -eq 1 ]]; then
	: >"$LOG_FILE"
	log "debug enabled"
fi

if ! command -v gum >/dev/null 2>&1; then
	printf "gum is required. Install gum and re-run.\n" >&2
	exit 1
fi

run_fs_op() {
	if [[ "$DRY_RUN" -eq 1 ]]; then
		printf "[dry-run]"
		for part in "$@"; do
			printf " %q" "$part"
		done
		printf "\n"
		return 0
	fi
	if [[ "$USE_SUDO" -eq 1 ]]; then
		log "run sudo: $*"
		sudo "$@"
	else
		log "run: $*"
		"$@"
	fi
}

select_destination() {
	while true; do
		local opt_local="$HOME/.local/bin"
		local opt_home="$HOME/bin"
		local opt_usr="/usr/local/bin"
		local pick

		if [[ -d "$opt_usr" && ! -w "$opt_usr" && "$DRY_RUN" -eq 0 ]]; then
			opt_usr="/usr/local/bin (requires sudo)"
		fi

		if ! pick="$(gum choose "$opt_local" "$opt_home" "$opt_usr")"; then
			log "destination choose cancelled"
			printf "Cancelled.\n"
			exit 0
		fi

		DEST_DIR="${pick%% (requires sudo)}"
		log "destination picked: $DEST_DIR"

		if [[ ! -d "$DEST_DIR" ]]; then
			if [[ "$DRY_RUN" -eq 1 ]]; then
				printf "[dry-run] mkdir -p %q\n" "$DEST_DIR"
			else
				if ! mkdir -p "$DEST_DIR" 2>/dev/null; then
					log "mkdir failed without sudo: $DEST_DIR"
					if ! gum confirm "Cannot create $DEST_DIR without sudo. Use sudo?"; then
						continue
					fi
					USE_SUDO=1
					log "using sudo enabled for mkdir"
					if ! run_fs_op mkdir -p "$DEST_DIR"; then
						printf "Failed to create destination directory: %s\n" "$DEST_DIR" >&2
						log "mkdir failed with sudo: $DEST_DIR"
						exit 1
					fi
				fi
			fi
		fi

		if [[ "$DRY_RUN" -eq 0 && ! -w "$DEST_DIR" ]]; then
			if [[ "$DEST_DIR" == "/usr/local/bin" ]]; then
				if gum confirm "Use sudo for linking into /usr/local/bin?"; then
					USE_SUDO=1
					log "using sudo enabled for /usr/local/bin"
				else
					continue
				fi
			else
				if gum confirm "Destination not writable. Use sudo?"; then
					USE_SUDO=1
					log "using sudo enabled for non-writable destination"
				else
					continue
				fi
			fi
		fi

		return 0
	done
}

check_path_conflict() {
	local link_name="$1"
	local src_real="$2"
	local existing

	existing="$(command -v "$link_name" 2>/dev/null || true)"
	if [[ -z "$existing" ]]; then
		CONFLICT_DECISION="continue"
		return 0
	fi

	local existing_real
	existing_real="$(readlink -f "$existing" 2>/dev/null || printf "%s" "$existing")"
	if [[ "$existing_real" == "$src_real" ]]; then
		CONFLICT_DECISION="already-same"
		return 0
	fi

	printf "'%s' already resolves to: %s\n" "$link_name" "$existing_real"
	if ! CONFLICT_DECISION="$(gum choose "continue-and-shadow" "rename-link" "skip")"; then
		CONFLICT_DECISION="skip"
	fi
	return 0
}

printf "Searching under: .\n"
mapfile -t candidates < <(find . -maxdepth 1 -type f \( -perm -u+x -o -name "*.sh" \) -print | sort -u)
log "raw candidates: ${#candidates[@]}"

filtered_candidates=()
for item in "${candidates[@]}"; do
	if [[ -n "${item:-}" ]]; then
		filtered_candidates+=("$item")
	fi
done
candidates=("${filtered_candidates[@]}")
log "filtered candidates: ${#candidates[@]}"

if [[ ${#candidates[@]} -eq 0 ]]; then
	printf "No executable or .sh files found in current folder.\n" >&2
	exit 1
fi

if ! selection_mode="$(gum choose "single-select" "multi-select" "select-all")"; then
	printf "Cancelled.\n"
	exit 0
fi

if [[ "$selection_mode" == "select-all" ]]; then
	selected=("${candidates[@]}")
	log "select-all mode chosen"
else
	while true; do
		if [[ "$selection_mode" == "single-select" ]]; then
			selected_raw="$(printf '%s\n' "${candidates[@]}" | gum choose || true)"
		else
			selected_raw="$(printf '%s\n' "${candidates[@]}" | gum choose --no-limit || true)"
		fi

		if [[ -n "${selected_raw:-}" ]]; then
			break
		fi
		log "no selection made"
		if gum confirm "No files selected. Try again?"; then
			continue
		fi
		printf "Cancelled.\n"
		exit 0
	done
	log "selected raw captured"

	filtered_selected=()
	while IFS= read -r item; do
		item="${item//$'\r'/}"
		if [[ -n "${item:-}" ]]; then
			filtered_selected+=("$item")
		fi
	done <<<"$selected_raw"
	selected=("${filtered_selected[@]}")
fi
log "selected count: ${#selected[@]}"

if [[ ${#selected[@]} -eq 0 ]]; then
	printf "Cancelled.\n"
	exit 0
fi

select_destination

if [[ "$USE_SUDO" -eq 1 && "$DRY_RUN" -eq 0 ]]; then
	log "requesting sudo validation"
	if ! sudo -v; then
		printf "Sudo authentication failed.\n" >&2
		log "sudo validation failed"
		exit 1
	fi
	log "sudo validation passed"
fi

if ! gum confirm "Link ${#selected[@]} file(s) into $DEST_DIR?"; then
	printf "Cancelled.\n"
	exit 0
fi

linked=0
skipped=0
failed=0

for src in "${selected[@]}"; do
	log "processing src: $src"
	if [[ -z "${src:-}" || ! -e "$src" ]]; then
		printf "Skipping invalid path: %s\n" "$src" >&2
		log "invalid src path"
		failed=$((failed + 1))
		continue
	fi
	if ! src_real="$(readlink -f -- "$src" 2>/dev/null)"; then
		printf "Skipping invalid path: %s\n" "$src" >&2
		log "readlink failed for src"
		failed=$((failed + 1))
		continue
	fi

	name="$(basename "$src")"
	dst="$DEST_DIR/$name"

	check_path_conflict "$name" "$src_real"
	log "conflict decision: $CONFLICT_DECISION for $name"
	if [[ "$CONFLICT_DECISION" == "skip" ]]; then
		skipped=$((skipped + 1))
		continue
	fi
	if [[ "$CONFLICT_DECISION" == "already-same" ]]; then
		if gum confirm "$name already resolves to same target. Relink anyway?"; then
			:
		else
			skipped=$((skipped + 1))
			continue
		fi
	fi
	if [[ "$CONFLICT_DECISION" == "rename-link" ]]; then
		if ! new_name="$(gum input --value "$name" --placeholder "New link name")"; then
			skipped=$((skipped + 1))
			continue
		fi
		if [[ -z "$new_name" ]]; then
			skipped=$((skipped + 1))
			continue
		fi
		name="$new_name"
		dst="$DEST_DIR/$name"
	fi

	while true; do
		log "destination candidate: $dst"
		if [[ -L "$dst" ]]; then
			current="$(readlink -f "$dst" 2>/dev/null || true)"
			if [[ "$current" == "$src_real" ]]; then
				if ! action="$(gum choose "skip" "relink")"; then
					skipped=$((skipped + 1))
					break
				fi
			else
				if ! action="$(gum choose "relink" "rename-link" "skip")"; then
					skipped=$((skipped + 1))
					break
				fi
			fi

			if [[ "$action" == "skip" ]]; then
				skipped=$((skipped + 1))
				break
			fi
			if [[ "$action" == "rename-link" ]]; then
				if ! new_name="$(gum input --value "$name" --placeholder "New link name")"; then
					skipped=$((skipped + 1))
					break
				fi
				if [[ -z "$new_name" ]]; then
					skipped=$((skipped + 1))
					break
				fi
				name="$new_name"
				dst="$DEST_DIR/$name"
				continue
			fi

			if run_fs_op rm -f "$dst" && run_fs_op ln -s "$src_real" "$dst"; then
				log "relinked $dst"
				linked=$((linked + 1))
			else
				printf "Failed to relink: %s -> %s\n" "$dst" "$src_real" >&2
				log "relink failed for $dst"
				failed=$((failed + 1))
			fi
			break
		elif [[ -e "$dst" ]]; then
			if ! action="$(gum choose "backup-and-link" "rename-link" "skip")"; then
				skipped=$((skipped + 1))
				break
			fi
			if [[ "$action" == "skip" ]]; then
				skipped=$((skipped + 1))
				break
			fi
			if [[ "$action" == "rename-link" ]]; then
				if ! new_name="$(gum input --value "$name" --placeholder "New link name")"; then
					skipped=$((skipped + 1))
					break
				fi
				if [[ -z "$new_name" ]]; then
					skipped=$((skipped + 1))
					break
				fi
				name="$new_name"
				dst="$DEST_DIR/$name"
				continue
			fi

			backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
			if run_fs_op mv "$dst" "$backup" && run_fs_op ln -s "$src_real" "$dst"; then
				log "backup and linked $dst"
				linked=$((linked + 1))
			else
				printf "Failed to backup/relink: %s\n" "$dst" >&2
				log "backup/relink failed for $dst"
				failed=$((failed + 1))
			fi
			break
		else
			if run_fs_op ln -s "$src_real" "$dst"; then
				log "linked $dst"
				linked=$((linked + 1))
			else
				printf "Failed to link: %s -> %s\n" "$dst" "$src_real" >&2
				log "link failed for $dst"
				failed=$((failed + 1))
			fi
			break
		fi
	done
done

printf "Done. linked=%s skipped=%s failed=%s\n" "$linked" "$skipped" "$failed"
log "done linked=$linked skipped=$skipped failed=$failed"
if [[ "$DEBUG" -eq 1 ]]; then
	printf "Debug log: %s\n" "$LOG_FILE"
fi

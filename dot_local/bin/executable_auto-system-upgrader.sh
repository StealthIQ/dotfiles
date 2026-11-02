#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/arch-update.conf"

# ---------- DEFAULTS ----------
AUTO=false
SKIP_MIRRORS=false
SKIP_PACMAN=false
SKIP_AUR=false
SKIP_PNPM=false
SKIP_BUN=false
SKIP_UV=false
SKIP_FLATPAK=true

# ---------- LOAD CONFIG ----------
[[ -f "$CONFIG" ]] && source "$CONFIG"

# ---------- SOUND ----------
notify() {
  printf "\a"
  command -v paplay >/dev/null &&
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || true
}

# ---------- SINGLE KEY PROMPT ----------
ask() {
  local msg="$1"
  printf "%s [y/n]: " "$msg"
  IFS= read -rsn1 key
  echo
  [[ "$key" =~ [Yy] ]]
}

# ---------- ARG PARSING ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
  --auto) AUTO=true ;;
  --skip)
    var="SKIP_$(echo "$2" | tr '[:lower:]' '[:upper:]')"
    declare "$var"=true
    shift
    ;;
  esac
  shift
done

# ---------- SUDO AUTH WITH SOUND ----------
echo "Sudo authentication required"
notify
sudo -v

# Keep sudo alive
(while true; do
  sudo -n true
  sleep 50
done) &
SUDO_KEEPALIVE_PID=$!

trap 'kill $SUDO_KEEPALIVE_PID' EXIT

# ---------- STEP RUNNER ----------
run_step() {
  local name="$1"
  local skip="$2"
  local cmd="$3"

  if [[ "$skip" == true ]]; then
    echo "⚠ Skipping $name (preset/flag)"
    return
  fi

  if $AUTO || ask "Run $name?"; then
    echo "==> $name"
    eval "$cmd"
  else
    echo "Skipped $name"
  fi
}

# ---------- MIRRORS ----------
run_step "Update mirrors" "$SKIP_MIRRORS" \
  'command -v reflector >/dev/null &&
 sudo reflector --latest 20 --protocol https --sort rate \
 --save /etc/pacman.d/mirrorlist'

# ---------- PACMAN ----------
run_step "Pacman system upgrade" "$SKIP_PACMAN" \
  'sudo pacman -Syu'

# ---------- ORPHANS ----------
run_step "Remove orphan packages" false \
  'orphans=$(pacman -Qdtq || true);
 [[ -n "$orphans" ]] && sudo pacman -Rns $orphans || true'

# ---------- CACHE ----------
run_step "Clean package cache" false \
  'sudo paccache -r -k 2'

# ---------- AUR ----------
run_step "AUR upgrade" "$SKIP_AUR" \
  'command -v paru >/dev/null && paru -Sua ||
 command -v yay >/dev/null && yay -Sua || true'

# ---------- GLOBAL DEV TOOLS (SAFE SUBSHELL) ----------
if [[ "$SKIP_PNPM" == true && "$SKIP_BUN" == true && "$SKIP_UV" == true ]]; then
  echo "⚠ Skipping global dev tools (preset/flag)"
else
  if $AUTO || ask "Update global dev tools (pnpm/bun/uv)?"; then
    echo "==> Updating global dev tools safely"
    (
      command -v pnpm >/dev/null && pnpm update -g || true
      command -v bun >/dev/null && bun upgrade --global || true
      command -v uv >/dev/null && uv tool upgrade --all || true
    ) || echo "Some global updates failed but continuing"
  fi
fi

# ---------- FLATPAK ----------
run_step "Flatpak update" "$SKIP_FLATPAK" \
  'command -v flatpak >/dev/null && flatpak update -y || true'

echo "✔ All updates complete"
notify

#!/usr/bin/env bash
# Keep the external display on the LEFT of the laptop panel, automatically.
#
#   external connected  ->  [ HDMI-A-1 @ 0x0 ] [ eDP-1 @ <external width> ]
#   external unplugged  ->  [ eDP-1 @ 0x0 ]
#
# Listens to Hyprland's socket2 events (monitoradded / monitorremoved /
# configreloaded) and re-applies the layout, so plugging or unplugging the
# screen needs no manual step. Safe to run more than once (single instance
# via flock) and it does nothing when the layout is already correct.
#
# Hyprland 0.56 runs the Lua config parser, where `hyprctl keyword` is
# rejected ("keyword can't work with non-legacy parsers"); changes therefore
# go through `hyprctl eval` + the hl.monitor() API.

set -u

LAPTOP="eDP-1"
EXTERNALS=("HDMI-A-1" "DP-1" "DP-2" "DP-3" "DP-4" "DP-5" "DP-6")
# Preferred mode per output. Used on hotplug instead of whatever mode the
# monitor came up in, so a replug never drops the refresh rate. Ignored when
# the mode is not advertised by the output (no black-screen risk).
declare -A EXTERNAL_MODES=(
    ["HDMI-A-1"]="2560x1440@100"
    ["DP-1"]="2560x1440@144"
)
SCALE="1"
LOCK="${XDG_RUNTIME_DIR:-/tmp}/hypr-monitor-layout.lock"
LOG="${XDG_RUNTIME_DIR:-/tmp}/hypr-monitor-layout.log"
SOCKET="${XDG_RUNTIME_DIR:-/tmp}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/.socket2.sock"

log() { printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$LOG"; }

field() { # $1=json $2=monitor name $3=field
    jq -r --arg n "$2" --arg f "$3" \
        '.[] | select(.name == $n) | .[$f] // empty' <<<"$1" 2>/dev/null | head -n1
}

usable() { # $1=json $2=monitor name  ->  prints "W H HZ" or returns 1
    local w h hz disabled
    w=$(field "$1" "$2" width)
    h=$(field "$1" "$2" height)
    hz=$(field "$1" "$2" refreshRate)
    disabled=$(field "$1" "$2" disabled)
    [[ -n $w && $w != 0 && -n $h && $h != 0 ]] || return 1
    [[ $disabled == "true" ]] && return 1
    printf '%s %s %s\n' "$w" "$h" "$hz"
}

mode_available() { # $1=json $2=name $3=mode  -> advertised by the output?
    local modes
    # availableModes is a JSON array, printed one mode per line. A configured
    # "2560x1440@100" is matched against advertised "2560x1440@100.00Hz".
    modes=$(jq -r --arg n "$2" \
        '.[] | select(.name == $n) | .availableModes[]? // empty' <<<"$1" 2>/dev/null)
    [[ -n $modes ]] || return 1
    grep -qF -- "$3" <<<"$modes"
}

set_monitor() { # name mode position scale
    local code out
    # disabled = false matters: a monitor left disabled at runtime is not
    # re-enabled by setting its mode alone, which would leave it dark.
    code=$(printf 'hl.monitor({ output = "%s", mode = "%s", position = "%s", scale = %s, disabled = false })' \
        "$1" "$2" "$3" "$4")
    if ! out=$(hyprctl eval "$code" 2>&1); then
        log "ERROR applying ${1} ${2} ${3}: ${out}"
        return 1
    fi
}

# Applies the layout once. Returns 2 when a monitor is present but has no
# geometry yet (caller should retry), 0 otherwise.
apply_layout() {
    local json ext="" ext_w ext_h ext_hz lap_w lap_h lap_hz cur_ext_x cur_lap_x
    json=$(hyprctl monitors -j 2>/dev/null) || { log "ERROR: hyprctl unavailable"; return 1; }
    [[ -n $json ]] || { log "ERROR: empty monitor list"; return 1; }

    local cand
    for cand in "${EXTERNALS[@]}"; do
        if read -r ext_w ext_h ext_hz < <(usable "$json" "$cand"); then
            ext=$cand
            break
        fi
        # Listed but still settling right after a hotplug.
        if [[ -n $(field "$json" "$cand" width) && $(field "$json" "$cand" disabled) != "true" ]]; then
            log "$cand present without geometry yet, will retry"
            return 2
        fi
    done

    if ! read -r lap_w lap_h lap_hz < <(usable "$json" "$LAPTOP"); then
        lap_w="" lap_h="" lap_hz=""
    fi

    if [[ -n $ext ]]; then
        local want_lap_x=$(( ext_w / SCALE ))
        local want_mode="${EXTERNAL_MODES[$ext]:-}"
        local ext_mode="${ext_w}x${ext_h}@${ext_hz}"
        local mode_ok=1
        if [[ -n $want_mode ]]; then
            if mode_available "$json" "$ext" "$want_mode"; then
                ext_mode="$want_mode"
                # Current refresh is compared as a prefix: 2560x1440@100
                # matches the reported 2560x1440@100.00000.
                [[ ${ext_w}x${ext_h}@${ext_hz} == "$want_mode"* ]] && mode_ok=0
            else
                # Never risk a mode the panel does not advertise.
                log "preferred mode $want_mode not advertised by $ext, keeping ${ext_hz}Hz"
                mode_ok=0
            fi
        fi

        cur_ext_x=$(field "$json" "$ext" x)
        cur_lap_x=$(field "$json" "$LAPTOP" x)

        if [[ ${cur_ext_x:-} == 0 && ${cur_lap_x:-} == "$want_lap_x" && $mode_ok == 0 ]]; then
            log "layout already correct: $ext at 0x0 (mode ${ext_w}x${ext_h}@${ext_hz}), $LAPTOP at ${want_lap_x}x0"
            return 0
        fi

        # External first, then shift the laptop to its right edge.
        set_monitor "$ext" "$ext_mode" "0x0" "$SCALE"
        if [[ -n $lap_w ]]; then
            set_monitor "$LAPTOP" "${lap_w}x${lap_h}@${lap_hz}" "${want_lap_x}x0" "$SCALE"
            log "external connected: $ext ${ext_mode} at 0x0 (left), $LAPTOP ${lap_w}x${lap_h} at ${want_lap_x}x0 (right)"
        else
            log "external connected: $ext ${ext_w}x${ext_h}@0x0 (left), $LAPTOP not available"
        fi
        return 0
    fi

    # No external: the laptop must own the origin, otherwise everything sits
    # offset with unusable dead space on its left.
    if [[ -n $lap_w ]]; then
        cur_lap_x=$(field "$json" "$LAPTOP" x)
        if [[ ${cur_lap_x:-} == 0 ]]; then
            log "layout already correct: laptop only at 0x0"
            return 0
        fi
        set_monitor "$LAPTOP" "${lap_w}x${lap_h}@${lap_hz}" "0x0" "$SCALE"
        log "external disconnected: $LAPTOP ${lap_w}x${lap_h} moved to 0x0"
        return 0
    fi

    log "no usable monitor found, leaving layout untouched"
    return 0
}

apply_with_retry() {
    local rc
    for _ in {1..10}; do
        apply_layout
        rc=$?
        [[ $rc -eq 2 ]] || return 0
        sleep 0.3
    done
    log "gave up waiting for monitor geometry"
}

watch_events() {
    local line now last_apply=0
    while true; do
        if [[ ! -S $SOCKET ]]; then
            sleep 1
            continue
        fi
        while IFS= read -r line; do
            case $line in
                monitoradded\>\>*|monitorremoved\>\>*|configreloaded\>\>*)
                    now=$(date +%s%N)
                    # Applying our own changes can emit events; ignore echoes.
                    if (( now - last_apply < 2000000000 )); then
                        continue
                    fi
                    sleep 0.6
                    apply_with_retry
                    last_apply=$(date +%s%N)
                    ;;
            esac
        done < <(socat -u UNIX-CONNECT:"$SOCKET" - 2>/dev/null)
        log "event socket closed, reconnecting"
        sleep 1
    done
}

mkdir -p "$(dirname "$LOG")"
exec 9>"$LOCK" 2>/dev/null || exit 0
flock -n 9 || exit 0

log "started (laptop=$LAPTOP, externals=${EXTERNALS[*]})"
apply_with_retry
watch_events

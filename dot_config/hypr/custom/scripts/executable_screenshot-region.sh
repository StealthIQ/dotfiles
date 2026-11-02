#!/usr/bin/env bash
# Region screenshot for Hyprland.
#   screenshot-region.sh          Super+Shift+S: freeze, drag a region, copy it
#                                 to the clipboard and save it. Nothing else.
#   screenshot-region.sh --edit   Ctrl+Shift+S: same, then open Satty so you can
#                                 draw on it (Enter/right-click = copy, Ctrl+S = save).
# Esc or right-click during the selection cancels. Screens are saved to
# ~/Pictures/Screenshots. Errors and timings: $XDG_RUNTIME_DIR/screenshot-region.log
#
# Why it was unreliable before (found 2026-10-30):
#  1. The freeze overlay (hyprpicker) and the selector (slurp) sit on the same
#     Wayland layer; whichever maps last is on top. The old script only waited
#     for the freeze on one monitor, so in ~1 of 7 runs the frozen image ended
#     up above slurp on a screen. Your clicks then went to hyprpicker, which
#     exits on click, and the selection "got stuck".
#  2. slurp allows one instance; a second press while one was still closing
#     made the new slurp exit at once, so nothing happened.
#  3. hyprshot (used before that) exited before grim finished writing.
#  4. "Works once, then never again": wl-copy stays running in the background
#     to serve the clipboard, and it inherited the lock file descriptor. The
#     lock stayed held until you copied something else, so every later press
#     was ignored. Every child now runs with the lock fd closed (9>&-).
# This version waits for the freeze on every monitor, checks slurp is on top
# (and drops the freeze instead of hanging if it is not), kills stale helpers,
# and has a watchdog so the screen can never stay frozen.

set -uo pipefail

MODE=copy
[[ "${1:-}" == "--edit" ]] && MODE=edit

RUN="${XDG_RUNTIME_DIR:-/tmp}"
LOG="$RUN/screenshot-region.log"
LOCK="$RUN/screenshot-region.lock"
OUT_DIR="$HOME/Pictures/Screenshots"
SELECT_TIMEOUT=120 # seconds before an unattended selection is abandoned
FREEZE_PID=""
SLURP_PID=""
TMP=""

log() { printf '[%s] %s %s\n' "$(date '+%F %T.%3N')" "$MODE" "$*" >>"$LOG"; }

cleanup() {
    [[ -n "$SLURP_PID" ]] && kill "$SLURP_PID" 2>/dev/null
    [[ -n "$FREEZE_PID" ]] && kill "$FREEZE_PID" 2>/dev/null
    [[ -n "$TMP" ]] && rm -f "$TMP" "$TMP.geom"
}
trap cleanup EXIT
trap 'exit 130' INT TERM HUP

fail() {
    log "ERROR: $*"
    notify-send -a Screenshot -u critical "Screenshot failed" "$* (log: $LOG)" 2>/dev/null 9>&- || true
    exit 1
}

# Layer-shell surfaces with a namespace, per monitor, in stacking order.
layers_json() { hyprctl layers -j 2>/dev/null; }
monitor_count() { hyprctl monitors -j 2>/dev/null | jq 'length'; }
count_layer() { layers_json | jq --arg ns "$1" '[.[] | .levels[] | .[] | select(.namespace == $ns)] | length'; }
# True when on every monitor the newest slurp surface is above the freeze.
slurp_on_top() {
    layers_json | jq -e '
        [ .[] | [ .levels["3"] // [] | to_entries[] | {i: .key, ns: .value.namespace} ] |
          ( [ .[] | select(.ns == "selection")  | .i ] | max ) as $s |
          ( [ .[] | select(.ns == "hyprpicker") | .i ] | max ) as $h |
          ($s != null) and ($h == null or $s > $h) ] | all' >/dev/null
}

for cmd in grim slurp wl-copy hyprpicker hyprctl jq notify-send; do
    command -v "$cmd" >/dev/null || fail "missing command: $cmd"
done
[[ "$MODE" == edit ]] && { command -v satty >/dev/null || fail "missing command: satty"; }

exec 9>"$LOCK" || fail "cannot open lock file $LOCK"
flock -n 9 || { log "already running, ignored"; exit 0; }

# Stale helpers from an earlier crash would block slurp (it allows one instance).
pkill -x slurp 2>/dev/null && log "killed a stale slurp"
pkill -x hyprpicker 2>/dev/null && log "killed a stale hyprpicker"
for _ in $(seq 20); do pgrep -x slurp >/dev/null || pgrep -x hyprpicker >/dev/null || break; sleep 0.05; done

mkdir -p "$OUT_DIR" || fail "cannot create $OUT_DIR"
TMP="$(mktemp --suffix=.png)" || fail "cannot create a temp file"
MONS="$(monitor_count)"
[[ "$MONS" =~ ^[0-9]+$ && "$MONS" -gt 0 ]] || fail "could not read monitors from hyprctl"

# 1. Freeze every monitor and wait until the frozen frame is up on all of them.
hyprpicker --render-inactive --no-zoom >/dev/null 2>>"$LOG" 9>&- &
FREEZE_PID=$!
frozen=0
for _ in $(seq 40); do # up to 2 s
    kill -0 "$FREEZE_PID" 2>/dev/null || break
    [[ "$(count_layer hyprpicker)" -ge "$MONS" ]] && { frozen=1; break; }
    sleep 0.05
done
if ((!frozen)); then
    log "freeze not ready on all $MONS monitors; continuing without freeze"
    kill "$FREEZE_PID" 2>/dev/null
    FREEZE_PID=""
fi

# 2. Start the selector and make sure it is above the freeze on every monitor.
slurp -d >"$TMP.geom" 2>>"$LOG" 9>&- &
SLURP_PID=$!
on_top=0
for _ in $(seq 40); do # up to 2 s
    kill -0 "$SLURP_PID" 2>/dev/null || break
    slurp_on_top && { on_top=1; break; }
    sleep 0.05
done
if ((!on_top)) && kill -0 "$SLURP_PID" 2>/dev/null; then
    log "selector ended up under the freeze; dropping the freeze so it stays usable"
    [[ -n "$FREEZE_PID" ]] && kill "$FREEZE_PID" 2>/dev/null
    FREEZE_PID=""
fi

# 3. Wait for the selection, with a watchdog so nothing stays frozen forever.
waited=0
while kill -0 "$SLURP_PID" 2>/dev/null; do
    sleep 0.1
    waited=$((waited + 1))
    if ((waited > SELECT_TIMEOUT * 10)); then
        log "no selection after ${SELECT_TIMEOUT}s, giving up"
        exit 0
    fi
    # If the freeze died mid-selection (e.g. a click reached it), keep going unfrozen.
    [[ -n "$FREEZE_PID" ]] && ! kill -0 "$FREEZE_PID" 2>/dev/null && { log "freeze exited during selection"; FREEZE_PID=""; }
done
wait "$SLURP_PID"
slurp_rc=$?
SLURP_PID=""
GEOM="$(head -n1 "$TMP.geom")"
if ((slurp_rc != 0)) || [[ -z "$GEOM" ]]; then
    log "selection cancelled (slurp exit $slurp_rc)"
    exit 0
fi
[[ "$GEOM" =~ ^-?[0-9]+,-?[0-9]+\ [0-9]+x[0-9]+$ ]] || fail "unexpected selection from slurp: '$GEOM'"

# 4. Capture from the frozen frame. slurp has already unmapped its surfaces.
timeout 10 grim -g "$GEOM" -t png "$TMP" 2>>"$LOG" 9>&- || fail "grim could not capture $GEOM"
[[ -s "$TMP" ]] || fail "capture of $GEOM came back empty"
[[ -n "$FREEZE_PID" ]] && kill "$FREEZE_PID" 2>/dev/null
FREEZE_PID=""

OUT="$OUT_DIR/$(date '+%Y-%m-%d_%H-%M-%S').png"

if [[ "$MODE" == copy ]]; then
    cp "$TMP" "$OUT" || fail "could not save $OUT"
    wl-copy --type image/png <"$OUT" 9>&- || fail "could not copy to the clipboard"
    log "ok $GEOM -> $OUT"
    notify-send -a Screenshot -i "$OUT" "Screenshot copied" "Saved to $OUT" 2>/dev/null 9>&- || true
    exit 0
fi

log "ok $GEOM -> editor"
satty --filename "$TMP" \
    --output-filename "$OUT" \
    --copy-command wl-copy \
    --early-exit \
    --actions-on-enter save-to-clipboard \
    2>>"$LOG" 9>&- || fail "satty exited with an error"

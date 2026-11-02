Goal

- Investigate Hyprland login loops/black screen and provide a way to persist logs automatically on every login.
  Progress
- Collected system info: Arch Linux, Hyprland 0.52.2, AMD 780M (T14 Gen 5), SDDM.
- Logs show SDDM repeatedly starts Hyprland session and falls back to greeter.
- xdg-desktop-portal-hyprland crashes when compositor isn’t up (symptom).
- Previous Hyprland coredumps (from earlier in convo) showed Aquamarine DRM connector crash; consistent with upstream AMD/Aquamarine issues.
- /dev/dri only has card1 (no card0), path /dev/dri/by-path/pci-0000:c4:00.0-card.
- No Hyprland logs in journald for current boot; Hyprland logs disabled by default.
- Identified config files: ~/.config/hypr/hyprland/general.conf, ~/.config/hypr/hyprland/execs.conf, ~/.config/hypr/custom/general.conf.
- Suggested optional fix: set AQ_DRM_DEVICES=/dev/dri/card1 in ~/.config/hypr/hyprland/env.conf (not applied).
- User asked for persistent logging solution.
- Recommended config additions:
  - debug:disable_logs = false (enable Hyprland file logs).
  - exec-once tail to mirror session log into ~/.config/hypr/logs/ per session:
    exec-once = sh -lc 'mkdir -p ~/.config/hypr/logs; LOG="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log"; while [ ! -f "$LOG" ]; do sleep 0.2; done; stdbuf -oL -eL tail -F "$LOG" >> "$HOME/.config/hypr/logs/$HYPRLAND_INSTANCE_SIGNATURE.log"'

Current State

- No edits performed. No files modified. We’re at recommendation stage.
  Blockers / Pending
- User has not asked to apply changes yet.
- If applying: need to edit ~/.config/hypr/hyprland/general.conf and ~/.config/hypr/hyprland/execs.conf.
- Optional: add AQ_DRM_DEVICES line to ~/.config/hypr/hyprland/env.conf (only if user asks).
  Next Step (if user wants changes)
- Insert debug:disable_logs = false in hyprland/general.conf.
- Add exec-once tail command in hyprland/execs.conf.
- Ask to reload Hyprland or relogin.

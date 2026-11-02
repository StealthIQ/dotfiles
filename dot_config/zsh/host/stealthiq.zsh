# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Host-specific Interactive Config (stealthiq)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Auto-start Hyprland on tty1 ---
# Only run in login shells
if [[ -o login ]]; then
    if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
        mkdir -p ~/.cache
        exec Hyprland > ~/.cache/hyprland.log 2>&1
    fi
fi

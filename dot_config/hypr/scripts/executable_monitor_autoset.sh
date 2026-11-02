#!/usr/bin/env bash
# Ported from your bspwm auto-monitor script to Hyprland
# Supports 3 monitors: eDP-1, DP-1, HDMI-1

INTERNAL="eDP-1"
DP="DP-1"
HDMI="HDMI-1"

# Detect monitors
mapfile -t outputs < <( hyprctl monitors -j | jq -r '.[].name' )

# 3 monitor setup check
if printf '%s\n' "${outputs[@]}" | grep -qx "$DP" && printf '%s\n' "${outputs[@]}" | grep -qx "$HDMI"; then
  # 3 monitor setup: eDP-1 (left), DP-1 (center), HDMI-1 (right)
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  hyprctl keyword monitor "$DP,2560x1440@60,1920x0,1"
  hyprctl keyword monitor "$HDMI,3840x2160@60,4480x0,1"
  
  # Workspace mapping
  hyprctl keyword workspace "1,monitor:$INTERNAL"
  for ws in {2..5}; do hyprctl keyword workspace "\$ws,monitor:$DP"; done
  for ws in {6..10}; do hyprctl keyword workspace "\$ws,monitor:$HDMI"; done

elif printf '%s\n' "${outputs[@]}" | grep -qx "$DP"; then
  # 2 monitor setup (DP-1)
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  hyprctl keyword monitor "$DP,2560x1440@60,1920x0,1"
  hyprctl keyword workspace "1,monitor:$INTERNAL"
  for ws in {2..10}; do hyprctl keyword workspace "\$ws,monitor:$DP"; done

elif printf '%s\n' "${outputs[@]}" | grep -qx "$HDMI"; then
  # 2 monitor setup (HDMI-1)
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  hyprctl keyword monitor "$HDMI,3840x2160@60,1920x0,1"
  hyprctl keyword workspace "1,monitor:$INTERNAL"
  for ws in {2..10}; do hyprctl keyword workspace "\$ws,monitor:$HDMI"; done

else
  # Internal only
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  for ws in {1..10}; do hyprctl keyword workspace "\$ws,monitor:$INTERNAL"; done
fi

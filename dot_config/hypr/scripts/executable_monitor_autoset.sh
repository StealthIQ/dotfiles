#!/usr/bin/env bash
# Emulates your xrandr logic using Hyprland monitor keywords and workspace mapping.
# External 4K DisplayPort + internal eDP split; else internal only.

set -euo pipefail

INTERNAL="eDP-1"
# Check real connector names: hyprctl monitors
EXTERNAL_CANDIDATES=$(hyprctl monitors -j | jq -r '.[].name' | grep -E 'DP|HDMI|USB-C' || true)

if [ -n "$EXTERNAL_CANDIDATES" ]; then
  EXT=$(echo "$EXTERNAL_CANDIDATES" | head -n1)
  # 4K external to the right, primary
  hyprctl keyword monitor "$EXT,3840x2160@60,1920x0,1"
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  # Workspace to monitor mapping (Hyprland persistent mapping)
  hyprctl keyword workspace "1,monitor:$EXT"
  hyprctl keyword workspace "2,monitor:$EXT"
  hyprctl keyword workspace "3,monitor:$EXT"
  hyprctl keyword workspace "4,monitor:$EXT"
  hyprctl keyword workspace "5,monitor:$EXT"
  hyprctl keyword workspace "6,monitor:$INTERNAL"
  hyprctl keyword workspace "7,monitor:$INTERNAL"
  hyprctl keyword workspace "8,monitor:$INTERNAL"
  hyprctl keyword workspace "9,monitor:$INTERNAL"
  hyprctl keyword workspace "10,monitor:$INTERNAL"
else
  hyprctl keyword monitor "$INTERNAL,1920x1080@60,0x0,1"
  # All 1..10 on internal
  for ws in {1..10}; do hyprctl keyword workspace "$ws,monitor:$INTERNAL"; done
fi

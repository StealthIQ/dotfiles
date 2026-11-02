#!/usr/bin/env bash

set -euo pipefail

INTERNAL="eDP-1"
EXTERNALS=("DP-1" "HDMI-A-1" "HDMI-1")
WORKSPACE_START=1
WORKSPACE_END=10

if ! command -v hyprctl >/dev/null 2>&1; then
	echo "Error: hyprctl not found. Run this inside a Hyprland session." >&2
	exit 1
fi

if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
	echo "Error: HYPRLAND_INSTANCE_SIGNATURE is not set. Are you in Hyprland?" >&2
	exit 1
fi

echo "[1/3] Forcing laptop panel layout on ${INTERNAL}..."
hyprctl keyword monitor "${INTERNAL},1920x1200@60,0x0,1" >/dev/null

echo "[2/3] Disabling known external outputs..."
for monitor in "${EXTERNALS[@]}"; do
	hyprctl keyword monitor "${monitor},disable" >/dev/null || true
done

echo "[3/3] Rebinding workspaces ${WORKSPACE_START}-${WORKSPACE_END} to ${INTERNAL}..."
hyprctl keyword workspace "1,monitor:${INTERNAL},default:true" >/dev/null
for workspace in $(seq "${WORKSPACE_START}" "${WORKSPACE_END}"); do
	if [[ "${workspace}" -eq 1 ]]; then
		continue
	fi
	hyprctl keyword workspace "${workspace},monitor:${INTERNAL}" >/dev/null
done

hyprctl dispatch workspace 1 >/dev/null || true

echo "Done: laptop-only recovery applied."

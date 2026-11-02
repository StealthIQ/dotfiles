# Hyprland Configuration & Solution Guide

This document details the architecture, configurations, and exact solutions applied to your Hyprland v0.56.2 setup on Arch Linux.

---

## 1. System Architecture & Hyprland Lua Engine

### Core Engine (`hyprland-lua`)
- **Lua Supremacy:** Hyprland v0.56.2 operates with the native Lua configuration parser enabled. All `.lua` files inside `~/.config/hypr/` override legacy `.conf` files.
- **Native Dispatchers (`hl.dsp.*`):** Dispatchers in `custom/keybinds.lua` use native Lua method calls rather than raw string execution.
  - Example: `hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })`
  - Example: `hl.dsp.focus({ workspace = 9 })`

---

## 2. Issues & Detailed Solutions

### Issue 1: Split-Screen Side-by-Side Fullscreen Videos (YouTube / Browsers)

#### Problem
When watching two videos side-by-side on Workspace 9 (Monitor `DP-1`) and pressing `f` on YouTube (or double-clicking a video), Hyprland defaulted to full-monitor fullscreen (`internal = 2`). One video expanded across the entire monitor (`2560x1440`), hiding the adjacent split window.

#### Root Cause
1. Browsers send a Wayland `set_fullscreen` client event when entering HTML5 fullscreen mode.
2. Without a matching rule in `custom/rules.lua`, Hyprland defaulted to full-monitor fullscreen.
3. Legacy rules in `custom/rules.conf` were ignored because Hyprland was running in Lua mode (`custom/rules.lua`).
4. Setting `internal = 3` included maximized/monitor fullscreen behaviors. The correct internal mode to keep windows tiled is `internal = 0`.

#### Solution
1. **Normal Startup Mode (No Automatic F11 on Launch):**
   - Removed static `fullscreen_state` rules from `custom/rules.lua` and `custom/rules.conf` so every browser opens in **standard normal tiled mode** on startup (with address bar and tabs intact).

2. **On-Demand Keybindings (`/home/stealthiq/.config/hypr/custom/keybinds.lua`):**
   ```lua
   hl.bind("SUPER + F", hl.dsp.window.fullscreen()) -- True Monitor Fullscreen
   hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen(1)) -- Maximize (Keep Bar)
   hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })) -- Split-Screen Fake Fullscreen
   hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 0 })) -- Reset to Normal Tiled Mode
   ```

#### How `{ internal = 0, client = 2 }` Works
- **`internal = 0` (None/Tiled):** Hyprland keeps the window **TILED in its 50/50 split-screen position**.
- **`client = 2` (Fullscreen):** Hyprland sends the fullscreen signal to the browser / HTML5 video player on demand when you press `Super + Shift + F`.
- **Result:** Browsers launch normally. When you want side-by-side full-screen video streaming, pressing `Super + Shift + F` expands the video to fill 100% of its half-screen split tile.

---

### Issue 2: Lua Parser Syntax Errors

#### Problem
Startup logs showed Lua errors (`hyprland.log`) due to `#` comments.

#### Solution
Replaced all shell-style `#` comments with double-hyphen `--` Lua comments across:
- `custom/env.lua`
- `custom/general.lua`
- `monitors.lua`
- `hyprland/general.lua`

---

### Issue 3: Triple Monitor Alignment

#### Setup & Order
Positioned monitors left-to-right in `hyprland/general.lua` and `monitors.lua`:
- **`eDP-1` (Laptop Screen):** `1920x1200@60` at `0x0`
- **`DP-1` (LG UltraGear 144Hz):** `2560x1440@144` at `1920x0` (Primary Monitor)
- **`HDMI-A-1` (LG UltraFine 4K):** `3840x2160@60` at `4480x0`

---

### Issue 4: Restored Workspace & Window Keybindings

All essential keybindings were restored in `custom/keybinds.lua`:
- **Workspace Switching:** `Super + 1..0` -> `hl.dsp.focus({ workspace = N })`
- **Move to Workspace:** `Super + Shift + 1..0` -> `hl.dsp.window.move({ workspace = N })`
- **Terminal:** `Super + Return` -> `kitty`
- **Close Window:** `Super + Q` -> `hl.dsp.window.close()`
- **Kill Window:** `Super + Shift + Q` -> `hyprctl kill`
- **Bar Toggle:** `Super + B` and `Super + J` -> Waybar & Quickshell toggle
- **App Launches:** Vicinae (`Super + A`, `Super + V`), Media Keys (`Super + F1..F3`).

---

### Issue 5: Dynamic Drive Mounting (`mount-drive-hhd`)

#### Problem
`mount-drive-hhd` failed because `/dev/sda1` was hardcoded, while external drives change device identifiers (`/dev/sda1`, `/dev/sdb1`, `/dev/sdc1`).

#### Solution
Rewrote `mount-drive-hhd` in `~/.config/fish/conf.d/50-functions.fish` (and synced to Chezmoi):
1. Queries `lsblk` for NTFS partitions dynamically.
2. Filters out active system mount points.
3. Clears dirty NTFS volume flags using `ntfsfix`.
4. Mounts the drive dynamically via `ntfs-3g` or `udisksctl`.

---

## 3. Verification & Maintenance Commands

To verify setup health at any time:
```bash
# Reload Hyprland configuration
hyprctl reload

# Check for syntax or config errors
hyprctl configerrors

# Check for runtime Lua errors in log
tail -n 30 $(ls -dt $XDG_RUNTIME_DIR/hypr/* | head -n 1)/hyprland.log | grep -i "Lua error"

# Capture screenshot of Workspace 9 (Monitor DP-1) only
grim -o DP-1 ~/.config/hypr/workspace9_preview.png
```

---

## 4. Keybinding Summary Reference

| Shortcut | Description |
| :--- | :--- |
| **`Super + W`** | Focus previous / last active window (`hl.dsp.focus({ urgent_or_last = true })`) |
| **`Super + Shift + S`** | Interactive region screenshot (`hyprshot -m region`) |
| **`Print`** | Full monitor screenshot (`hyprshot -m output`) |
| **`Super + Print`** | Active window screenshot (`hyprshot -m window`) |
| **`Alt + Print`** | Region screenshot (`hyprshot -m region`) |
| **`f` (inside YouTube)** | Expands video to 100% of tiled split window (`internal = 0, client = 2`) |
| **`Super + Shift + F`** | Force split-screen fakefullscreen on focused window |
| **`Super + Ctrl + F`** | Reset window fullscreen state back to standard tiled |
| **`Super + F`** | True full-monitor fullscreen |
| **`Super + Alt + F`** | Maximize window (keeps top bar) |
| **`Super + Shift + V`** | Toggle zero gaps for borderless video watching |
| **`Super + B` / `Super + J`** | Toggle Waybar / Quickshell status bars |
| **`Super + 1..0`** | Switch active workspace |
| **`Super + Shift + 1..0`** | Move window to workspace |

---

### Quickshell Workspace Clickability Fix
- **Issue:** Clicking workspace buttons in Quickshell did not switch workspaces because Quickshell sent legacy string dispatches `workspace N`, which threw Lua syntax errors in Hyprland v0.56.2.
- **Fix:** Updated `~/.config/quickshell/ii/modules/ii/bar/Workspaces.qml` to emit native Lua dispatches: `Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspaceValue + " })")`.


-- Restored Original Custom Keybindings
---@module 'hl'

local mainMod = "SUPER"
local shift = "SHIFT"
local alt = "ALT"
local ctrl = "CTRL"

-- Edit Config Shortcuts
hl.bind("CTRL + SUPER + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json"))
hl.bind("CTRL + SUPER + ALT + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"))

-- Terminal & Window Management
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin || thunar"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
-- Super+W: flip between the last two windows (A -> B -> A -> B ...).
-- Hyprland's own "last" focus walks back through the whole focus history,
-- so we remember the previous and current window ourselves and swap them.
local focusPrev, focusCur = nil, nil
hl.on("window.active", function(w)
	if not w or not w.address or w.address == focusCur then
		return
	end
	focusPrev, focusCur = focusCur, w.address
end)
hl.bind("SUPER + W", function()
	if not focusPrev then
		return
	end
	for _, w in ipairs(hl.get_windows()) do
		if w.address == focusPrev and w.mapped then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. focusPrev }))
			return
		end
	end
end) -- Toggle between the last two windows
hl.bind("SUPER + ALT + W", hl.dsp.focus({ last = true }))
hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "-1" }))

-- Screenshot Keybindings (Single binding to prevent double triggering)
-- Screenshots (both freeze the screens; the region can span monitors; Esc cancels)
--   Super+Shift+S  region -> clipboard + ~/Pictures/Screenshots. Nothing else.
--   Ctrl+Shift+S   region -> Satty editor to draw on it (Enter = copy, Ctrl+S = save).
--                  Note: this takes Ctrl+Shift+S away from apps ("Save as").
-- Script and the reasons it used to hang: custom/scripts/screenshot-region.sh
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/screenshot-region.sh")) -- Screenshot region to clipboard
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/screenshot-region.sh --edit")) -- Screenshot region and draw on it
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(
	"SUPER + SHIFT + E",
	hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/screenshot-ocr.sh"),
	{ description = "Screenshot to text (OCR)" }
)

-- Bar / Waybar / Quickshell Hiding Toggles
hl.bind(
	"SUPER + B",
	hl.dsp.exec_cmd("killall -SIGUSR1 waybar || pkill -USR1 waybar || hyprctl dispatch global quickshell:barToggle")
)
hl.bind("SUPER + J", hl.dsp.global("quickshell:barToggle"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("pkill -USR1 waybar || waybar &"))

-- Fullscreen modes
--   Super+F            Maximize: the window fills its monitor's work area. The
--                      Quickshell bar, gaps and borders stay visible; other
--                      monitors are untouched. Press again to restore.
--   Super+Shift+F      Real fullscreen: covers the whole monitor, bar hidden.
--   Both only change Hyprland's side (client = 0). The app is not told it is
--   fullscreen, because Brave/BrowserOS answer that by asking to leave
--   fullscreen, and the browser rule in custom/rules.lua lets that through,
--   so the window snapped back after a second or two.
--   Super+Ctrl+Shift+F Fake fullscreen: the app thinks it is fullscreen (e.g. a
--                      browser video) but stays inside its tile.
--   Super+Ctrl+F       Reset the window to normal tiled state.
--   Super+G            Toggle window borders on/off for all windows.
hl.bind("SUPER + F", hl.dsp.window.fullscreen_state({ internal = 1, client = 0, action = "toggle" })) -- Maximize (keep bar)
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 1, client = 0, action = "toggle" })) -- Maximize (keep bar)
-- Super+Shift+F: if the window is in any fullscreen state (real, maximized or
-- fake from Super+Ctrl+Shift+F), go back to normal; otherwise go real fullscreen.
hl.bind("SUPER + SHIFT + F", function()
	local w = hl.get_active_window()
	if not w then
		return
	end
	if w.fullscreen ~= 0 or w.fullscreen_client ~= 0 then
		hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 0 }))
	else
		hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 2, client = 0 }))
	end
end) -- Real fullscreen / exit any fullscreen
hl.bind("SUPER + CTRL + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })) -- Fake fullscreen inside the tile
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 0 })) -- Reset fullscreen state to tiled

local savedBorderSize = nil
hl.bind("SUPER + G", function()
	local current = hl.get_config("general.border_size")
	if current ~= 0 then
		savedBorderSize = current
		hl.config({ general = { border_size = 0 } })
	else
		hl.config({ general = { border_size = savedBorderSize or 1 } })
	end
end) -- Toggle window borders
hl.bind("SUPER + ALT + G", hl.dsp.global("quickshell:overlayToggle")) -- Quickshell overlay (moved off Super+G)

-- Super+/ : searchable list of every keybind (fuzzel)
hl.bind("SUPER + Slash", hl.dsp.exec_cmd("~/.config/hypr/custom/scripts/keybinds-cheatsheet.py")) -- Show all keybinds

-- Workspace Switching (Super + 1..0)
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Move Window to Workspace (Super + Shift + 1..0)
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- App Quick Launches
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + F8", hl.dsp.exec_cmd("thunar || brave"))
hl.bind("SUPER + F9", hl.dsp.exec_cmd("Telegram"))
hl.bind("SUPER + F11", hl.dsp.exec_cmd("brave --incognito"))
hl.bind("SUPER + F12", hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd("ulauncher-toggle"))

-- Media Controls (Playerctl / MPC)
hl.bind("SUPER + F1", hl.dsp.exec_cmd("playerctl play-pause || mpc toggle"), { locked = true })
hl.bind("SUPER + F2", hl.dsp.exec_cmd("playerctl next || mpc next"), { locked = true })
hl.bind("SUPER + F3", hl.dsp.exec_cmd("playerctl previous || mpc prev"), { locked = true })

-- Clipboard History & Vicinae Launcher
hl.unbind("SUPER + V") -- drop the default Quickshell/fuzzel clipboard binds from hyprland/keybinds.lua
hl.bind("SUPER + V", hl.dsp.exec_cmd("vicinae 'vicinae://launch/clipboard/history?toggle=true'")) -- Vicinae Clipboard History
hl.bind(
	"SUPER + ALT + V",
	hl.dsp.exec_cmd("pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy")
) -- Fast Fuzzel Cliphist Search
hl.bind("SUPER + A", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("vicinae 'vicinae://launch/clipboard/history?toggle=true'"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/core/search-emojis"))
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("promptforge --professor --sound"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("bash ~/.config/sxhkd/scripts/tele_vids.sh")) -- Telegram Desktop videos (top level only, resumes)
hl.bind("CTRL + X", hl.dsp.exec_cmd("bash ~/.config/sxhkd/scripts/tele_vids.sh --kill")) -- Quit mpv, saving playback position

-- Mouse Binds
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Optional private additions (not in the public repo)
package.loaded["custom.private"] = nil
if package.searchpath("custom.private", package.path) then
    local ok, err = pcall(require, "custom.private")
    if not ok then print("WARN: custom.private: " .. tostring(err)) end
end

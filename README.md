# StealthIQ dotfiles

Arch Linux + Hyprland (Lua config) on a ThinkPad T14 Gen 5 (Ryzen 7 PRO 8840U, Radeon 780M), managed with [chezmoi](https://www.chezmoi.io/).

| Part | What |
|---|---|
| Compositor | Hyprland 0.56, Lua config (`~/.config/hypr/hyprland.lua`) |
| Shell UI | Quickshell with the end-4 **illogical-impulse** (`ii`) shell |
| Terminal | kitty |
| Shells | zsh (`ZDOTDIR=~/.config/zsh`, oh-my-zsh + powerlevel10k) and fish (tide) |
| History | atuin (Ctrl+R, shared between zsh and fish, local only) |
| Editor | Neovim (lazy.nvim) |
| Theming | matugen (Material You from the wallpaper), Kvantum, GTK 3/4 |
| Launchers | Quickshell search, vicinae, fuzzel |
| Screenshots | grim + slurp + hyprpicker freeze, Satty for drawing |

## Install on a new machine

```sh
# 1. Base packages (Arch). Pick what you need; the full list is in packages/.
sudo pacman -S --needed chezmoi git hyprland kitty zsh fish neovim fuzzel \
    grim slurp wl-clipboard hyprpicker satty jq libnotify atuin

# 2. Pull the dotfiles and see what would change before applying.
#    `chezmoi init` asks two yes/no questions: download the optional private
#    layer (only works with access to it), and install the package lists.
chezmoi init https://github.com/StealthIQ/dotfiles.git
chezmoi diff
chezmoi apply

# 3. oh-my-zsh is not vendored in this repo; install it into ZDOTDIR
ZSH="$HOME/.config/zsh/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
```

The illogical-impulse Quickshell shell has its own installer and dependencies: see [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland). This repo only carries my configured copy.

## Update

A user timer (`chezmoi-push.timer`, Sundays 03:00) runs `dotfiles-autopush`: it copies the
live configs into the repo, blocks the commit if gitleaks finds a secret, then pushes.
Run `dotfiles-autopush` to do it now. Log: `~/.local/state/dotfiles-autopush.log`.

Optional per-machine additions live in files that load only when present
(`hypr/custom/private/`, `zsh/conf.d/90-private.zsh`, `fish/conf.d/90-private.fish`,
`nvim/lua/plugins/private.lua`) and are not part of this repo.

## Keybinds

`Super` is the Windows key. Press **Super + /** to search every active bind on the machine.
The full list lives in [`dot_config/hypr/custom/keybinds.lua`](dot_config/hypr/custom/keybinds.lua) and [`dot_config/hypr/hyprland/keybinds.lua`](dot_config/hypr/hyprland/keybinds.lua).

### Windows and fullscreen

| Keys | Action |
|---|---|
| Super + Return | kitty |
| Super + Q | Close window |
| Super + Shift + Q | Kill window (`hyprctl kill`) |
| Super + W | Toggle between the last two windows |
| Super + F | Maximize: fills the monitor, keeps bar, gaps and borders. Press again to restore |
| Super + Shift + F | Real fullscreen (hides the bar). Also exits fake fullscreen |
| Super + Ctrl + Shift + F | Fake fullscreen: the app thinks it is fullscreen but stays in its tile |
| Super + Ctrl + F | Reset window to normal tiled |
| Super + G | Toggle window borders on/off (all windows) |
| Super + drag (left / right mouse) | Move / resize window |

Fullscreen binds only change Hyprland's side (`client = 0`). Chromium browsers (e.g. Brave) otherwise ask to leave fullscreen and snap back after a second.

### Workspaces

| Keys | Action |
|---|---|
| Super + 1 … 0 | Go to workspace 1 … 10 |
| Super + Shift + 1 … 0 | Move window to workspace 1 … 10 |
| Super + Tab / Super + Shift + Tab | Next / previous workspace |

### Screenshots

| Keys | Action |
|---|---|
| Super + Shift + S | Freeze screens, drag a region, copy + save to `~/Pictures/Screenshots` |
| Ctrl + Shift + S | Same, then open Satty to draw on it (Enter = copy, Ctrl+S = save) |
| Super + Shift + E | Screenshot to text (OCR) |
| Print / Super + Print / Alt + Print | Whole monitor / window / region (hyprshot) |

The script is [`dot_config/hypr/custom/scripts/executable_screenshot-region.sh`](dot_config/hypr/custom/scripts/executable_screenshot-region.sh). Its header documents the bugs it works around (freeze overlay stacking above slurp, slurp's single-instance lock, wl-copy inheriting the lock).

### Shell, launchers and apps

| Keys | Action |
|---|---|
| Super (tap) | Quickshell search |
| Super + / | Searchable list of all keybinds |
| Super + A | vicinae |
| Super + V / Super + Alt + V | Clipboard history (vicinae / fuzzel) |
| Super + Period | Emoji picker |
| Super + Alt + G | Quickshell overlay |
| Super + J / Super + B | Toggle bar |
| Super + E | File manager |
| Super + F11 / F12 | Brave incognito / Obsidian |
| Super + Shift + R | Reload Hyprland |

### Media

| Keys | Action |
|---|---|
| Super + F1 / F2 / F3 | Play-pause / next / previous |
| Super + X / Ctrl + X | Telegram videos in mpv / quit mpv saving position |

### Touchpad gestures

| Gesture | Action |
|---|---|
| 3-finger swipe | Move window |
| 3-finger pinch | Float window |
| 4-finger left / right | Switch workspace |
| 4-finger up / down | Open / close the workspace overview |

## Layout

```
dot_config/
  hypr/            hyprland.lua + hyprland/ (shell defaults) + custom/ (my overrides, scripts)
  quickshell/ii/   illogical-impulse shell
  illogical-impulse/  shell settings (config.json)
  kitty/ fish/ zsh/ nvim/ matugen/ Kvantum/ fuzzel/ wlogout/ satty/ mpv/
  systemd/user/    ActivityWatch, quickshell, espanso, weekly auto-push units
dot_local/bin/     personal scripts
```


## What is deliberately not here

Secrets and machine state are excluded by `.chezmoiignore` and checked with gitleaks before every push:
API keys and account files, host env files (`host/*.env.*`), KDE Connect keys, shell history, fish universal variables, caches, `node_modules`, and the vendored oh-my-zsh.

Repository history was rewritten on 2026-11-02 to remove previously committed secrets. Old branches are kept under `archive/`.

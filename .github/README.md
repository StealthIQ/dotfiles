## My Arch Linux Dotfiles

*These dotfiles are a hot mess in progress - an experiment in tinkering, not a production-ready setup! Use at your own risk.*

### Setup Details

- Operating System: Arch Linux
- Window Manager: bspwm
- Compositor: picom
- Terminal: st (luke's fork)
- Shell: ZSH
- Bar: polybar
- File Manager: ranger + ueberzug (image support for the terminal)
- Notifications: dunst
- Music Player: Mpd + Ncmpcpp
- Visualizer: cava
- Hotkey Daemon: skhd
- Prompt: powerline10k
- Font: iosevka
- Pipe-like Thing: pipes.sh

### Frequently Asked Questions (FAQ)

#### General Questions

1. **How does my theme change according to the wallpaper?**
   - I use a tool called pywal, which automatically extracts colors from the wallpaper and applies them to the theme.

2. **How do I add an audio visualizer to the bar?**
   - I utilize a script from [this GitHub repository](https://github.com/username/repo) (you will need mpd).

3. **What's the name of the music playing?**
   - The current track is "Take Off" by Chris Heria. You can find it on Spotify (download using SpotiFlyer).

4. **Have a question not listed here?**
   - Feel free to ask, and I'll do my best to provide an answer.

## My Keybindings 

#### Window Management

| Keybind                  | Action                                     |
|--------------------------|--------------------------------------------|
| <kbd>super + enter</kbd> | Spawn terminal                             |
| <kbd>super + shift + enter</kbd> | Spawn floating terminal              |
| <kbd>super + d</kbd>     | Launch rofi                                |
| <kbd>super + shift + q</kbd> | Close client                           |
| <kbd>super + control + space</kbd> | Toggle floating client            |
| <kbd>super + [1-0]</kbd> | View tag / Change workspace (for i3 folks) |
| <kbd>super + shift + [1-0]</kbd> | Move focused client to tag        |
| <kbd>super + s</kbd>     | Tiling layout                              |
| <kbd>super + shift + s</kbd> | Floating layout                          |
| <kbd>super + w</kbd>     | Maximized / Monocle layout                 |
| <kbd>super + [arrow keys]</kbd> | Change focus by direction          |
| <kbd>super + [hjkl]</kbd> | ^                                           |
| <kbd>super + shift + [arrow keys]</kbd> | Move client by direction        |
| <kbd>super + shift + [hjkl]</kbd> | ^                                    |
| <kbd>super + control + [arrow keys]</kbd> | Resize client                   |
| <kbd>super + control + [hjkl]</kbd> | ^                                       |
| <kbd>super + f</kbd>     | Toggle fullscreen                          |
| <kbd>super + m</kbd>     | Toggle maximize                            |
| <kbd>super + n</kbd>     | Minimize                                   |
| <kbd>super + shift + n</kbd> | Restore minimized                     |
| <kbd>super + c</kbd>     | Center floating client                     |
| <kbd>super + u</kbd>     | Jump to urgent client (or back to last tag if there is no such client) |
| <kbd>super + b</kbd>     | Toggle bar                                 |
| <kbd>super + =</kbd>     | Toggle tray                                |

#### Miscellaneous Actions

| Keybind                  | Action                                      |
|--------------------------|---------------------------------------------|
| <kbd>super + e</kbd>     | Launch VS Code                              |
| <kbd>super + r ; r</kbd> | Launch Librewolf Browser (Normal mode)     |
| <kbd>super + r ; p</kbd> | Launch Librewolf Browser (Private mode)    |
| <kbd>super + c</kbd>     | Toggle conky                                |
| <kbd>super + x</kbd>     | Toggle MPV                                  |
| <kbd>super + shift + c</kbd> | Launch Bleachbit                      |
| <kbd>super + l ; l ; s</kbd> | Suspend system                           |
| <kbd>super + l ; l ; b</kbd> | Lock screen with Betterlockscreen       |
| <kbd>super + l ; l ; i</kbd> | Lock screen with i3-lock-fancy          |
| <kbd>super + g ; r ; t</kbd> | Open Rofi theme selector                 |
| <kbd>super + m</kbd>     | Open Power menu                            |
| <kbd>super + a</kbd>     | Toggle Ulauncher                            |
| <kbd>ctrl + space</kbd>  | Open Rofi menu                              |
| <kbd>super + d</kbd>     | Open Rofi script menu                       |
| <kbd>super + shift + v</kbd> | Open pavucontrol                           |
| <kbd>super + semicolon</kbd> | Open Emoji Selector                      |
| <kbd>super + t</kbd>     | Open terminal (kitty)                      |
| <kbd>super + Return</kbd> | Open terminal (ST)                         |
| <kbd>super + y</kbd>     | Hide Polybar                               |
| <kbd>super + shift + y</kbd> | Hide Polybar and remove gaps             |

#### Multimedia Keys

| Keybind                  | Action                                      |
|--------------------------|---------------------------------------------|
| <kbd>XF86AudioRaiseVolume</kbd> | Increase volume                         |
| <kbd>XF86AudioLowerVolume</kbd> | Decrease volume                         |
| <kbd>XF86AudioMute</kbd> | Mute volume                                |
| <kbd>XF86AudioPlay</kbd> | Toggle play/pause (music player)         |
| <kbd>XF86AudioNext</kbd> | Play next song (music player)             |
| <kbd>XF86AudioPrev</kbd> | Play previous song (music player)         |
| <kbd>XF86AudioStop</kbd> | Stop music (music player)                  |
| <kbd>XF86MonBrightnessUp</kbd> | Increase brightness                      |
| <kbd>XF86MonBrightnessDown</kbd> | Decrease brightness                      |

### Bspwm Hotkeys

#### Window Management

| Keybind                  | Action                                      |
|--------------------------|---------------------------------------------|
| <kbd>super + shift + r</kbd> | Quit/Restart bspwm and sxhkd              |
| <kbd>alt + shift + r</kbd> | Reload sxhkd                               |
| <kbd>super + shift + Delete</kbd> | Quit bspwm                             |
| <kbd>super + {_,shift + }q</kbd> | Close and kill client                   |
| <kbd>super + space</kbd> | Alternate between the tiled and monocle layout |
| <kbd>super + f</kbd> | Set focused window to fullscreen mode     |
| <kbd>super + shift + f</kbd> | Set focused window to fullscreen mode (partial) |
| <kbd>super + shift + a</kbd> | Set focused window to tiled layout       |
| <kbd>super + shift + s</kbd> | Set focused window to floating layout    |
| <kbd>super + shift + f</kbd> | Set focused window to fullscreen layout  |
| <kbd>super + f</kbd> | Set focused window to fullscreen layout (partial) |
| <kbd>super + control + [1-9]</kbd> | Move focused window to desktop X      |
| <kbd>super + control + space</kbd> | Cancel preselection for focused node   |
| <kbd>super + control + shift + space</kbd> | Cancel preselection for focused desktop |
| <kbd>super + shift + {Left,Down,Up,Right}</kbd> | Move floating window |
| <kbd>super + shift + {h,j,k,l}</kbd> | Expand/Contract a window                  |

#### Miscellaneous Actions

| Keybind                  | Action                                      |
|--------------------------|---------------------------------------------|
| <kbd>super + g ; g ; p</kbd> | Generate random password (Bitwarden)    |
| <kbd>super + z</kbd> | Run Nitro

plex script                      |
| <kbd>super + x</kbd> | Run Nitroplex script (redundant)         |
| <kbd>super + shift + y</kbd> | Hide Polybar and remove gaps             |

### Multimedia Keys

| Keybind                  | Action                                      |
|--------------------------|---------------------------------------------|
| <kbd>XF86AudioRaiseVolume</kbd> | Increase volume                         |
| <kbd>XF86AudioLowerVolume</kbd> | Decrease volume                         |
| <kbd>XF86AudioMute</kbd> | Mute volume                                |
| <kbd>XF86AudioPlay</kbd> | Toggle play/pause (music player)         |
| <kbd>XF86AudioNext</kbd> | Play next song (music player)             |
| <kbd>XF86AudioPrev</kbd> | Play previous song (music player)         |
| <kbd>XF86AudioStop</kbd> | Stop music (music player)                  |
| <kbd>XF86MonBrightnessUp</kbd> | Increase brightness                      |
| <kbd>XF86MonBrightnessDown</kbd> | Decrease brightness                      |

### Feedback

If you have any feedback or suggestions, please reach out to me via email at stealthiq[at]protonmail[.]com or [Twitter](https://twitter.com/StealthIQQ).

### Author

- [@Stealthiq](https://www.github.com/stealthiq)

### License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).

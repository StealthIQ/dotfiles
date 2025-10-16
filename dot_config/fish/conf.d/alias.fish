# -------------------------------------------------------
# Basics
set -gx EDITOR nvim
set -gx PAGER less

alias vim "nvim"
alias v "nvim"
alias code "codium"
alias nano "nvim"

# -------------------------------------------------------
# Package management
function pacs; pacman -Ss $argv; end
function paci; sudo pacman -S $argv; end
function pacr; sudo pacman -Rns $argv; end
alias pakages "pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias pkglast "expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n "
alias update-system "sudo pacman -Syu"
alias update-system-all "sudo pacman -Syyu"
alias inst "paru -S --noconfirm --needed"
alias force-remove "sudo pacman -Rd --nodeps"
alias unlock "sudo rm /var/lib/pacman/db.lck"
alias cleanup "sudo pacman -Qtdq | sudo pacman -Rns -"
alias mirror "sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord "sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors "sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora "sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# -------------------------------------------------------
# Safer file operations
alias cp "cp -i"
alias mv "mv -i"
alias rm "trash"
# skip 'rm -rf' alias; fish cannot define alias with spaces safely
function rmtree
    trash $argv
end

alias bleachbit-shred-trash "bleachbit -s ~/.local/share/Trash"

# -------------------------------------------------------
# Utilities
alias grep "grep --color=auto"
alias egrep "egrep --color=auto"
alias fgrep "fgrep --color=auto"
alias df "df -h"
alias free "free -m"

# -------------------------------------------------------
# Navigation (Zoxide)
alias cd "z"

# -------------------------------------------------------
# ls -> eza
function ls; exa -al --color=always --hyperlink --group-directories-first $argv; end
function ll; eza --icons -la $argv; end
function la; eza --icons -a $argv; end
function lla; eza --icons -lah $argv; end
function lt; eza --tree -la $argv; end
function l1; eza --icons -1 $argv; end

# -------------------------------------------------------

# pipr fix: real function
function pipr
    if test (count $argv) -lt 1
        echo "Usage: pipr <requirements-file>"
        return 1
    end
    for package in (cat $argv[1])
        if test -n "$package"
            echo "Installing $package ..."
            uv pip install "$package"
        end
    end
end


# -------------------------------------------------------
# Config shortcuts
alias kittyrc "vim ~/.config/kitty/kitty.conf"
alias hyprc "vim ~/.config/hypr/hyprland.conf"
alias rc "vim ~/.config/fish/conf.d/alias.fish"
alias nvimrc "vim ~/.config/nvim/init.lua"
alias bspwmrc "vim ~/.config/bspwm/bspwmrc"
alias sxhkdrc "vim ~/.config/sxhkd/sxhkdrc"
alias polybar-modules "vim ~/.config/polybar/modules.ini"
alias xinitrc "vim ~/.xinitrc"
alias picomrc "vim ~/.config/picom/picom.conf"
alias xres "vim ~/.Xresources"

# -------------------------------------------------------
alias r "ranger"
alias k "killall"
alias art "clear && ~/.config/neofetch/ascii_art/unix"
alias kitty-themes "kitty +kitten themes"
alias clear-wal-cache "echo '' > ~/.wallpapers/.wall-cache/used_wallpapers.txt"
alias ncmpcpp "ncmpcpp -c ~/.config/ncmpcpp/config"
alias rec-noaudio "ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i \$DISPLAY -c:v ffvhuff ~/Videos/Screen_Recording/Recording-(date +%B-%d-%Y_%H:%M:%S).mp4"
alias rec-intaudio "ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i :0.0 -f pulse -i default -preset ultrafast -crf 18 -pix_fmt yuv420p ~/Videos/Screen_Recording/Recording_Internal-Audio(date +%B-%d-%Y_%H:%M:%S).mp4"
alias rr "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias pi "python3"
alias jav "javac (ls -tr *.java | tail -n1); and java (basename (ls -tr *.class | tail -n1) .class)"
alias conky "conky --config=$HOME/.config/conky/.conkyrc"
alias clip "xclip -selection clipboard"
alias t-stream "python ~/MEGAsync/Projects/Python/torrent-strm/Main/_xmain_.py"
alias pax "python3 ~/MEGAsync/Projects/Python/passfx/main.py"
alias yt-trans "python3 ~/Documents/MEGAsync/Projects/Python/Youtube-transcript-extractor/main.py"
alias tic-tac-toe "python3 ~/tools/Tic-Tac-Toe/tictactoe.py"
alias t "task"
alias tui "taskwarrior-tui"
alias disk-analyzer "ncdu"
alias disk-mounter "sudo blkmenu"
alias gad "git add"
alias gcm "git commit -m"
alias clone "git clone"
alias wallpaper-change "feh --bg-scale"
alias dmenu "~/.config/sxhkd/scripts/dmenu.sh"
alias fzf "fzf -e"

# -------------------------------------------------------
# Custom clean-up helpers
function bleachbit-cleanup
    bleachbit --list | grep --color=auto -E "[a-z0-9_\-]+\.[a-z0-9_\-]+" | xargs bleachbit --clean
end

function wifi-range
    watch -n1 "awk 'NR==3 {printf(\"WiFi Signal Strength = %.0f%%\\n\",\$3*10/7)}' /proc/net/wireless"
end

# -------------------------------------------------------
# Config shortcuts
alias kittyrc "vim ~/.config/kitty/kitty.conf"
alias hyprc "vim ~/.config/hypr/hyprland.conf"
alias rc "vim ~/.config/fish/conf.d/alias.fish"
alias nvimrc "vim ~/.config/nvim/init.lua"
alias bspwmrc "vim ~/.config/bspwm/bspwmrc"
alias sxhkdrc "vim ~/.config/sxhkd/sxhkdrc"
alias polybar-modules "vim ~/.config/polybar/modules.ini"
alias xinitrc "vim ~/.xinitrc"
alias picomrc "vim ~/.config/picom/picom.conf"
alias xres "vim ~/.Xresources"

# -------------------------------------------------------
# Unified RC navigation
function ASPTRC
    if test (count $argv) -eq 0
        vim ~/.config
        return
    end
    set t (string lower $argv[1])
    switch $t
        case kitty
            vim ~/.config/kitty/kitty.conf
        case hypr
            vim ~/.config/hypr/hyprland.conf
        case fish
            vim ~/.config/fish/config.fish
        case nvim
            vim ~/.config/nvim/init.lua
        case bspwm
            vim ~/.config/bspwm/bspwmrc
        case sxhkd
            vim ~/.config/sxhkd/sxhkdrc
        case polybar
            vim ~/.config/polybar/modules.ini
        case picom
            vim ~/.config/picom/picom.conf
        case xresources
            vim ~/.Xresources
        case '*'
            if test -d ~/.config/$t
                vim ~/.config/$t
            else
                echo "No config found for $t"
            end
    end
end

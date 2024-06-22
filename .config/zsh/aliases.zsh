#------- MAIN ALIASES --------

# Root privileges
alias doas="doas --"

#hello
# Navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done 

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

# Code Editor - Vim, Codium
alias vim="nvim"
alias code="codium \$(pwd)"

# Changing "ls" to "exa"
alias l='ls'
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing

# Pacman and Paru - (package manager)
alias pakages="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias pkglast="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n "
alias update-system='sudo pacman -Syu'           # update only standard pkgs
alias update-system-all='sudo pacman -Syyu'      # Refresh pkglist & update standard pkgs
alias inst='paru -S --noconfirm --needed'        # install pakages
alias force-remove='sudo pacman -Rd --nodeps'    # force remove pakages
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Qtdq | sudo pacman -Rns -'  # remove orphaned packages

# Get fastest mirrors for - ARCH
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'

# Remove it into trash
alias rm="trash"
alias 'rm -rf'="trash-file"
alias bleachbit-shred-trash="bleachbit -s ~/.local/share/Trash"

# Adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# Get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "
# Only Video
alias ytv-list="yt-dlp -i -f mp4 --yes-playlist "
alias ytv-mp4="yt-dlp -i -f mp4 "

# Switch between shells easily
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

#Leftwm aliases
alias lti="leftwm-theme install"
alias ltu="leftwm-theme uninstall"
alias lta="leftwm-theme apply"
alias ltupd="leftwm-theme update"
alias ltupg="leftwm-theme upgrade"

alias wifir="sudo systemctl restart NetworkManager"
alias wifi="bash /$HOME/.config/rofi/rofi-network-manager/rofi-network-manager.sh"
alias cd="z"
alias hh="history"
alias kc="killall conky"
alias ck="conky"
alias lock='betterlockscreen -l --text "Error 404: Display not found"'
alias logout="loginctl kill-session $XDG_SESSION_ID"
alias myip="curl ifconfig.co/"
alias vi="neovide "
alias batr="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias grub="sudo vim /etc/default/grub"
alias rldb="killall xidlehook && killall sxhkd && bspc wm -r"
# alias net-signal="watch -n1 "awk 'NR==3 {printf(\"WiFi Signal Strength = %.0f%%\\n\",\$3*10/7)}' /proc/net/wireless"" # https://askubuntu.com/questions/95676/a-tool-to-measure-signal-strength-of-wireless
alias window-identify="xprop | grep WM_CLASS"

#files
alias rc="vim ~/.config/zsh/aliases.zsh"
alias bspwmrc="vim ~/.config/bspwm/bspwmrc"
alias sxhkdrc="vim ~/.config/sxhkd/sxhkdrc"
alias polybar-modules="vim ~/.config/polybar/modules.ini"
alias xinitrc="vim ~/.xinitrc"
alias picomrc="vim ~/.config/picom/picom.conf"

# File Manager
alias thunar="thunar \$(pwd)"
alias r="ranger"
alias k="killall"
alias art="clear && /home/$USER/.config/neofetch/ascii_art/unix"
alias kitty-themes="kitty +kitten themes"

#ncmpcpp custom
alias clear-wal-cache='echo "" > ~/.wallpapers/.wall-cache/used_wallpapers.txt'
alias ncmpcpp='ncmpcpp -c ~/.config/ncmpcpp/config'

#Screen Recording - No Audio + w/ Audio - ffmped
alias rec-noaudio="ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i \$DISPLAY -c:v ffvhuff ~/Videos/Screen_Recording/Recording-\$(date +%B-%d-%Y_%H:%M:%S).mp4"
alias rec-intaudio="ffmpeg -f x11grab -video_size 1920x1080 -framerate 25 -i :0.0 -f pulse -i default -preset ultrafast -crf 18 -pix_fmt yuv420p ~/Videos/Screen_Recording/Recording_Internal-Audio\$(date +%B-%d-%Y_%H:%M:%S).mp4"

# Terminal rickroll :)
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# Personal/Programming
alias pi="python3 "
alias pipr='function myfunc_for_pip_install() { while IFS= read -r package; do if [ -n "$package" ]; then echo "Installing using uv pip installer - $package..."; uv pip install "$package"; fi; done < "$1"; }; myfunc_for_pip_install'
alias jav='javac "$(command ls -tr *.java | tail -n1)" && java "$(basename "$(command ls -tr *.class | tail -n1)" .class)"'

# Conky 
alias conky="conky --config=$HOME/.config/conky/.conkyrc"

# clipboard
alias clip='xclip -selection clipboard'

# Personal/Scripts
alias t-stream='python ~/MEGAsync/Projects/Python/torrent-strm/Main/_xmain_.py'
alias pax="python3 ~/MEGAsync/Projects/Python/passfx/main.py"
alias yt-trans="python3 ~/MEGAsync/Projects/Python/Youtube-transcript-extractor/main.py"

# Personal/Games
alias tic-tac-toe="python3 ~/tools/Tic-Tac-Toe/tictactoe.py"

# Github 
alias gad='git add'
alias gcm='git commit -m'

# --- Alias as Functions ----
bleachbit-cleanup() {
bleachbit --list | grep --color=auto -E "[a-z0-9_\-]+\.[a-z0-9_\-]+" | xargs bleachbit --clean
}
wifi-range() {
watch -n1 "awk 'NR==3 {printf(\"WiFi Signal Strength = %.0f%%\\n\",\$3*10/7)}' /proc/net/wireless"
}

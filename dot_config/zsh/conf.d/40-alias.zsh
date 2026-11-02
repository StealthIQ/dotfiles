# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Aliases
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Core Overrides ---
alias ls="eza -a --group-directories-first"
alias l="eza --group-directories-first"
alias ll="eza -lh --icons --git --no-user --no-group --header --group-directories-first"
alias la="eza -alh --icons --git --header --group-directories-first"
alias lt="eza --tree --level=2 --group-directories-first"
alias lx="eza -lh --git --no-user --no-group --header --group-directories-first"
alias lsn="eza -al --icons --color=always --no-hyperlink --group-directories-first"

alias grep="grep --color=auto"
alias df="df -h"
alias free="free -m"
alias clear="printf '\033[2J\033[3J\033[1;1H'"

# --- Safety ---
alias cp="cp -i"
alias mv="mv -i"
alias rm="trash"

# --- Utilities ---
alias q="qs -c ii"
alias clip="xclip -selection clipboard"
alias gen-secret-key="openssl rand -hex 32"
alias fzf-bat="fzf --preview 'bat --color=always {}'"
alias fzf="fzf --preview 'bat --color=always {}' -e"
alias r="yazi"
alias k="killall"

# --- Development Shortcuts ---
alias pm="pnpm run dev"
alias bro="pnpm run dev"
alias broi="pnpm install"

# --- Package Management (Typos & Misc) ---
alias pamcan="pacman"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias cleanup="sudo pacman -Qtdq | sudo pacman -Rns -"
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

# --- Legacy / Misc ---
alias thunar="dolphin ."
alias bleachbit-shred-trash="bleachbit -s ~/.local/share/Trash"

# --- Git Aliases ---
alias gitp="git-auto-push"

# --- Disk Analysis ---
alias disk-analyze="ncdu"

alias mount-toshiba="sudo mount -t ntfs-3g -o remove_hiberfile /dev/sda1 /mnt/external-toshiba-1 "


alias kill-high-cpu="top -b -n 1 | head -n 10 | grep -A 10 PID | tail -n +2 | head -n 1 | awk '{print $1}' | xargs kill -9"




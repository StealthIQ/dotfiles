function rmtree; trash $argv; end
alias unlock "sudo rm /var/lib/pacman/db.lck"
alias cleanup "sudo pacman -Qtdq | sudo pacman -Rns -"
alias force-remove "sudo pacman -Rd --nodeps"
alias clip 'xclip -selection clipboard'
alias uvv "source ~/.venv/bin/activate.fish"
alias gcm "git commit -m"
alias clone "git clone"
alias gpush "bash ~/.local/bin/git-auto-push"
alias nvim-gitignore "nvim ~/.gitignore_global"

# Config Editing Shortcuts
# -------------------------------------------------------
alias kittyrc "nvim ~/.config/kitty/kitty.conf"
alias hyprc "nvim ~/.config/hypr/hyprland.conf"
alias fishrc "nvim ~/.config/fish/config.fish"
alias rc "nvim ~/.config/fish/conf.d/40-alias.fish"
alias nvimrc "nvim ~/.config/nvim/init.lua"
alias bspwmrc "nvim ~/.config/bspwm/bspwmrc"
alias sxhkdrc "nvim ~/.config/sxhkd/sxhkdrc"
alias polybar-modules "nvim ~/.config/polybar/modules.ini"
alias xinitrc "nvim ~/.xinitrc"
alias picomrc "nvim ~/.config/picom/picom.conf"
alias xres "nvim ~/.Xresources"
# -------------------------------------------------------

alias gen-secret-key "openssl rand -hex 32"
alias fzf-bat "fzf --preview 'bat --color=always {}'"
alias fzf "fzf --preview 'bat --color=always {}' -e"

alias pnpmd "pnpm run dev"
alias pm "pnpm run dev"
alias npmi "pnpm install"
alias bro "pnpm run dev"

alias thunar "dolphin ."
alias gitp "bash ~/.local/bin/git-auto-push"
alias git-ignore-global "nvim ~/.gitignore_global"

alias ls "eza -al --color=always --hyperlink --group-directories-first"
alias lsn "eza -al --color=always --no-hyperlink --group-directories-first"

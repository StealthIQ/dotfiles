# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Abbreviations (Converted to Aliases for Zsh)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Note: In Fish, abbreviations expand when typing. In Zsh, we use aliases.
# For true abbreviation behavior, install the zsh-abbr plugin after setting up OMZ:
#   git clone https://github.com/olets/zsh-abbr ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-abbr

# --- Git ---
alias gad='git add'
alias gcm='git commit -m'
alias gco='git checkout'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gdd='git branch -D'
alias clone='git clone --depth 1'

# --- Package Management ---
# Note: pacs, paci, pacr are defined as functions in 50-functions.zsh
alias inst='paru -S --noconfirm --needed'
alias update-arch-system='sudo pacman -Syyu --noconfirm'
alias upp='sudo pacman -Syyu'

# --- Navigation ---
# Note: zoxide 'z' command loaded separately, keeping cd as-is for completion compatibility
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Editors ---
alias v='nvim'
alias vim='nvim'
alias nano='nvim'

# --- Development ---
alias pdev='pnpm run dev'
alias pinst='pnpm install'
alias pbuild='pnpm run build'
alias uvv='source ~/.venv/bin/activate'

# --- Language Helpers ---
alias pi='python3'
alias jav='javac *.java && java $(basename *.class .class)'

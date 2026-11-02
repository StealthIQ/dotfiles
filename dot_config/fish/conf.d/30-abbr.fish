# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Abbreviations (Expanded Visibly)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Git ---
abbr -a gad  'git add'
abbr -a gcm  'git commit -m'
abbr -a gco  'git checkout'
abbr -a gst  'git status'
abbr -a gl   'git pull'
abbr -a gp   'git push'
abbr -a gdd  'git branch -D'
abbr -a clone 'git clone --depth 1'

# --- Package Management ---
abbr -a pacs 'pacman -Ss'
abbr -a paci 'sudo pacman -S'
abbr -a pacr 'sudo pacman -Rns'
abbr -a inst 'paru -S --noconfirm --needed'
abbr -a up   'sudo pacman -Syu'
abbr -a upp  'sudo pacman -Syyu'

# --- Navigation ---
abbr -a cd   'z'
abbr -a ..   'z ..'
abbr -a ...  'z ../..'
abbr -a .... 'z ../../..'

# --- Editors ---
abbr -a v    'nvim'
abbr -a vim  'nvim'
abbr -a nano 'nvim'

# --- Development ---
abbr -a pdev 'pnpm run dev'
abbr -a pinst 'pnpm install'
abbr -a pbuild 'pnpm run build'
abbr -a uvv  'source ~/.venv/bin/activate'

# --- Language Helpers ---
abbr -a pi   'python3'
abbr -a jav  'javac *.java && java (basename *.class .class)'

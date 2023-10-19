# ----- Env Variables -----

# Pyenv  
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"

# Rust
export RUST="$HOME/.cargo/bin"

# XDG
export XDG_DATA_HOME="$HOME/.local/share" 
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache" 
export XDG_STATE_HOME="$HOME/.local/state"

#brew    
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Zoxide insted of cd
eval "$(zoxide init zsh)"
# Pyenv
eval "$(pyenv init - zsh)"

unalias z
function z () {
    __zoxide_z "$@"
}
# Local Scripts
export PATH="$PATH:$HOME/.local/bin"

# Lang
export LANG=en_US.UTF-8
# Spicetify
export PATH=$PATH:/home/stealthiq/.spicetify

# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519

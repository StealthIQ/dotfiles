# ----- Env Variables -----

# Pyenv  
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"

# Rust
export RUST="$HOME/.cargo/bin"

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

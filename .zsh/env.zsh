# ----- Env Variables -----

# Pyenv  
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Rust
export RUST="$HOME/.cargo/bin"


# Zoxide insted of cd
eval "$(zoxide init zsh)"

unalias z
function z () {
    __zoxide_z "$@"
}

# Spicetify
export PATH=$PATH:/home/StealthIQ/.spicetify


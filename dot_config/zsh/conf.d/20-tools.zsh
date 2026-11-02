# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# External Tools Initialization
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Starship Prompt ---
# Disabled: Using Powerlevel10k instead
# if command -v starship &> /dev/null; then
#     eval "$(starship init zsh)"
# fi

# --- Zoxide (Smarter cd) ---
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"

    # Wrap z to handle no-argument case (cd without args goes to home)
    cd() {
        if [[ $# -eq 0 ]]; then
            builtin cd ~
        else
            z "$@"
        fi
    }
    alias cdi="zi"

    # Use standard cd completion
    compdef '_cd' cd 2>/dev/null || true
fi

# --- FZF integration ---
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
fi

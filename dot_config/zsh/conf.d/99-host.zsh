# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Host-specific configurations
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This file loads host-specific environment variables and configurations
# from the 'host/' subdirectory based on the current environment.

# Load all host-specific environment files first
for env_file in "${ZDOTDIR:-$HOME/.config/zsh}/host"/*.env.zsh(N); do
    if [[ -f "$env_file" ]]; then
        source "$env_file"
    fi
done

# Load all host-specific config files (only in interactive shells)
if [[ -o interactive ]]; then
    for host_file in "${ZDOTDIR:-$HOME/.config/zsh}/host"/*.zsh(N); do
        # Skip .env.zsh files (already loaded) and backup files
        if [[ "$host_file" == *.env.zsh ]] || [[ "$host_file" == *~ ]]; then
            continue
        fi
        if [[ -f "$host_file" ]]; then
            source "$host_file"
        fi
    done
fi

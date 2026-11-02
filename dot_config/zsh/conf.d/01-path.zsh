# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Zsh path configuration with idempotent additions

# Function to add to PATH if not already present
path_add() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$PATH:$1"
    fi
}

# System-wide and user-specific binaries
path_add "$HOME/.local/bin"
path_add "$HOME/.local/share/pnpm"
path_add "$HOME/.cargo/bin"

# GPU and ROCm paths
export HSA_OVERRIDE_GFX_VERSION=11.0.0
export ROCM_PATH=/opt/rocm
export PATH=$PATH:$ROCM_PATH/bin

# Add pnpm to PATH if not already present
if [[ -n "$PNPM_HOME" ]] && [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
    export PATH="$PATH:$PNPM_HOME"
fi

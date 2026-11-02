# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Using fish_add_path for idempotent and smart path management.

# System-wide and user-specific binaries
fish_add_path -m $HOME/.local/bin
set -Ux PNPM_HOME $HOME/.local/share/pnpm
if set -l idx (contains -i $HOME/.local/share/pnpm $PATH)
    set -e PATH[$idx]
end
fish_add_path -m $HOME/.local/share/pnpm/bin
fish_add_path -m $HOME/.cargo/bin

# Fix Playwright MCP path on Arch Linux
set -Ux PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH /usr/bin/chromium

set -Ux DISABLE_TELEMETRY 1
set -Ux DO_NOT_TRACK 1

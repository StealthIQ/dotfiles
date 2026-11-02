# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Global Environment Variables
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export EDITOR=nvim
export VISUAL=nvim
export PAGER=bat
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Use global scope for better performance and consistency
export GPG_TTY=$(tty)

# Disable telemetry
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1

# Fix Playwright MCP path on Arch Linux
export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"

# bun
export PATH="/home/stealthiq/.bun/bin:$PATH" 

# ===== Dev Network Fixes =====

# Prefer IPv4 (fixes npm/pnpm/bun timeouts)
export NODE_OPTIONS="--dns-result-order=ipv4first"

# pnpm global path
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PATH:$PNPM_HOME"

# Playwright optional (skip huge downloads)
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

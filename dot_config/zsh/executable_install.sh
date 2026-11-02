#!/usr/bin/env bash
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Zsh Configuration Installation Script
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script helps install the migrated Zsh configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ZSH_DIR="$HOME/.config/zsh"
FISH_DIR="$HOME/.config/fish"

# Helper functions
print_info() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Oh My Zsh is installed
check_oh_my_zsh() {
	if [[ -d "$HOME/.oh-my-zsh" ]]; then
		print_success "Oh My Zsh is already installed"
		return 0
	else
		print_warning "Oh My Zsh is not installed"
		return 1
	fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
	print_info "Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	print_success "Oh My Zsh installed successfully"
}

# Backup existing zsh config
backup_existing() {
	if [[ -f "$HOME/.zshrc" ]] && [[ ! -L "$HOME/.zshrc" ]]; then
		print_info "Backing up existing .zshrc..."
		mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
		print_success "Backup created"
	fi

	if [[ -f "$HOME/.zshenv" ]] && [[ ! -L "$HOME/.zshenv" ]]; then
		print_info "Backing up existing .zshenv..."
		mv "$HOME/.zshenv" "$HOME/.zshenv.backup.$(date +%Y%m%d%H%M%S)"
		print_success "Backup created"
	fi
}

# Create symlinks
create_symlinks() {
	print_info "Creating symlinks..."

	# Remove existing symlinks if they point elsewhere
	[[ -L "$HOME/.zshrc" ]] && rm "$HOME/.zshrc"
	[[ -L "$HOME/.zshenv" ]] && rm "$HOME/.zshenv"

	# Create new symlinks
	ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
	ln -sf "$ZSH_DIR/.zshenv" "$HOME/.zshenv"

	print_success "Symlinks created"
}

# Check for dependencies
check_dependencies() {
	print_info "Checking dependencies..."

	local deps=("starship" "zoxide" "fzf" "eza" "trash" "yazi" "xclip")
	local missing_deps=()

	for dep in "${deps[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			missing_deps+=("$dep")
		fi
	done

	if [[ ${#missing_deps[@]} -gt 0 ]]; then
		print_warning "Missing dependencies: ${missing_deps[*]}"
		print_info "Install them with: sudo pacman -S ${missing_deps[*]}"
		print_info "Note: Some packages may be in AUR (yazi, starship)"
	else
		print_success "All dependencies are installed"
	fi
}

# Install optional plugins
install_optional_plugins() {
	print_info "Installing optional plugins..."

	# zsh-abbr for Fish-like abbreviations
	if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-abbr" ]]; then
		print_info "Installing zsh-abbr (Fish-like abbreviations)..."
		git clone https://github.com/olets/zsh-abbr "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-abbr" 2>/dev/null || true
	fi

	# zsh-syntax-highlighting
	if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
		print_info "Installing zsh-syntax-highlighting..."
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" 2>/dev/null || true
	fi

	# zsh-autosuggestions
	if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
		print_info "Installing zsh-autosuggestions..."
		git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" 2>/dev/null || true
	fi

	print_success "Optional plugins installed"
}

# Change default shell
change_shell() {
	if [[ "$SHELL" == *"zsh"* ]]; then
		print_success "Zsh is already your default shell"
	else
		print_info "Changing default shell to zsh..."
		if chsh -s "$(which zsh)"; then
			print_success "Default shell changed to zsh"
			print_warning "Please log out and back in for the change to take effect"
		else
			print_error "Failed to change shell. You may need to run: chsh -s $(which zsh)"
		fi
	fi
}

# Main installation
main() {
	echo ""
	echo "╔════════════════════════════════════════════════════════════╗"
	echo "║        Zsh Configuration Installation Script               ║"
	echo "║        Migrated from Fish Shell                            ║"
	echo "╚════════════════════════════════════════════════════════════╝"
	echo ""

	# Check if we're in the right directory
	if [[ ! -f "$ZSH_DIR/.zshrc" ]]; then
		print_error "Zsh configuration not found at $ZSH_DIR"
		print_info "Make sure this script is run after the zsh config is created"
		exit 1
	fi

	# Check Oh My Zsh
	if ! check_oh_my_zsh; then
		read -p "Install Oh My Zsh? (y/N) " -n 1 -r
		echo
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			install_oh_my_zsh
		else
			print_warning "Oh My Zsh is required. Install it manually first."
			exit 1
		fi
	fi

	# Backup existing config
	backup_existing

	# Create symlinks
	create_symlinks

	# Check dependencies
	check_dependencies

	# Install optional plugins
	read -p "Install optional plugins (zsh-abbr, syntax-highlighting, autosuggestions)? (y/N) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		install_optional_plugins
	fi

	# Change shell
	read -p "Change default shell to zsh? (y/N) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		change_shell
	fi

	echo ""
	echo "╔════════════════════════════════════════════════════════════╗"
	echo "║        Installation Complete!                              ║"
	echo "╚════════════════════════════════════════════════════════════╝"
	echo ""
	print_success "Zsh configuration installed successfully!"
	echo ""
	echo "Next steps:"
	echo "  1. Start a new zsh shell: zsh"
	echo "  2. Or log out and back in to use zsh by default"
	echo "  3. Review the README at: $ZSH_DIR/README.md"
	echo ""
	echo "Your Fish config is preserved at: $FISH_DIR"
	echo "To go back to Fish: chsh -s \$(which fish)"
	echo ""
}

# Run main function
main "$@"

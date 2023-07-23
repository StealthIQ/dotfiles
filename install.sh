#!/bin/bash
# Script to install dotfiles for Arch Linux
# by StealthIQ

# Defined Colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)

# Basic Variables
dotfilesrepo="https://github.com/StealthIQ/dotfiles.git"
aurhelper="paru"
current_dir="$PWD"
packages_file="$current_dir/misc/packages.txt"

export TERM=ansi

# MAIN FUNCTIONS

fix_locale(){
    echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment
    echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
    echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.conf
    sudo locale-gen en_US.UTF-8
}

fix_time(){
    sudo su
    pacman -S --noconfirm --needed ntp
    systemctl enable ntpd
    timedatectl set-ntp 1
  }

installpkg() {
    # Use parallel processing for faster installation
    cat "$packages_file" | parallel --will-cite --bar "$aurhelper -S --noconfirm --needed {}"
}
error_s() {
    # Log to stderr and exit with failure.
    printf "${red}%s\n${reset}" "$1" >&2
    exit 1
}

nvchad_install() {
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
    rm -rf "$HOME/.local/state/nvim/shada"
}

bootloader_theme() {
    git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
    cd Top-5-Bootloader-Themes
    sudo ./install.sh
}

spotify_themer(){
    # Install spicetify-cli package using paru
    paru -S --noconfirm --needed spicetify-cli

    # Define variables for paths
    spotify_path="/opt/spotify"
    spicetify_config="$HOME/.config/spicetify/config-xpui.ini"
    spicetify_themes_repo="https://github.com/spicetify/spicetify-themes.git"
    spicetify_themes_dest="$HOME/.config/spicetify/Themes"

    # Ensure the Spotify directory exists and has proper permissions (optional)
    # sudo mkdir -p "$spotify_path"
    # sudo chmod -R 777 "$spotify_path"

    # Check if the spicetify config file exists before proceeding
    if [ ! -f "$spicetify_config" ]; then
        echo "Error: Spicetify config file not found at $spicetify_config. Run 'spicetify -c' to set it up."
        exit 1
    fi

    # Run spicetify commands
    echo "Setting up Spicetify..."
    spicetify && \
    spicetify backup apply enable-devtool && \
    spicetify update

    # Clone the spicetify-themes repository
    echo "Cloning spicetify-themes repository..."
    cd "$HOME/Downloads/" && git clone "$spicetify_themes_repo" && \
    cd "spicetify-themes" && \
    cp -r * "$spicetify_themes_dest"

    # Apply the desired theme and color scheme
    echo "Applying the Sleek theme and Psycho color scheme..."
    spicetify config current_theme Sleek && \
    spicetify config color_scheme Psycho && \
    spicetify apply

    echo "Spicetify setup is complete."
}

welcome_msg() {
    clear

    printf "${cyan}Welcome to StealthIQ Arch Linux Setup\n"
    printf "${blue}This script will automatically install all the necessary packages,\n"
    printf "I use and make sure you get the exact same setup as me\n\n${reset}"

    read -p "Do you want to continue? (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "${green}Continuing with the script..."
    else
        clear
        echo "${red}Exiting the script."
        exit
    fi
}

install_pkg() {
    while read -r LINE; do
        $aurhelper -S --noconfirm --needed "$LINE"
    done < "$packages_file"
}

move_and_link_dotfiles() {
    # Create Old-backups directory if it doesn't exist
    mkdir -p "$HOME/Old-Backups"

    # Move .config folder files and create backups if needed
    mv -n "$HOME/.config"/* "$HOME/Old-backups/" 2>/dev/null

    # Move .fonts and .icons to $HOME
    mv -n "$current_dir/misc/.fonts" "$HOME" 2>/dev/null
    mv -n "$current_dir/misc/.icons" "$HOME" 2>/dev/null

    # Move local/bin folder files to $HOME/local/bin
    mkdir -p "$HOME/local/bin"
    mv -n "$current_dir/.local/bin"/* "$HOME/.local/bin" 2>/dev/null

    # Move .wallpaper to $HOME/.wallpaper
    mkdir -p "$HOME/.wallpaper"
    mv -n "$current_dir/misc/.wallpapers"/* "$HOME/.wallpaper" 2>/dev/null

    # Create symlinks for .conkyrc and .zshrc
    ln -sf "$HOME/.config/conky/.conkyrc" "$HOME"
    ln -sf "$HOME/.config/zsh/.zshrc" "$HOME"

    # Move .xinitrc to $HOME and make it executable
    mv -n "$current_dir/.xinitrc" "$HOME" 2>/dev/null
    chmod +x "$HOME/.xinitrc"
}

main() {
    welcome_msg
    install_pkg
    # move_and_link_dotfiles
    # spotify_themer
    # nvchad_install
    # bootloader_theme

    echo "${green}Installation completed successfully.${reset}"
    echo "Please restart your system or re-login for all changes to take effect."
}

main

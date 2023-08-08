#!/bin/bash
# Script to install dotfiles for Arch Linux
# by StealthIQ

# Define Colors
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

# Error handling function
error_msg() {
    printf "${red}%s\n${reset}" "$1" >&2
    exit 1
}

fix_keyring_error() {
    sudo pacman -Sy --needed --noconfirm archlinux-keyring
    sudo pacman-key --refresh
}

base_pkg() {
    sudo pacman -Syu --noconfirm --needed base-devel sof-firmware neovim
}

# Check if a command is available
command_exists() {
    command -v "$1" &>/dev/null
}


# Install packages using the AUR helper
install_packages() {
    local package_manager="$1"
    local package_list="$2"
    if command_exists "$package_manager"; then
        cat "$package_list" | parallel --will-cite --bar "$package_manager -S --noconfirm --needed {}"
    else
        error_msg "$package_manager is not installed."
    fi
}

inst_pkg(){
    while read -r LINE; do
        paru -S --noconfirm --needed "$LINE"
    done < "$packages_file"
}
# Git clone and install from AUR
install_from_aur() {
    local package_name="$1"
    if [[ ! -d "$package_name" ]]; then
        git clone "https://aur.archlinux.org/$package_name.git"
        (cd "$package_name" && makepkg -si)
    else
        echo "$package_name is already installed."
    fi
}

# Update locale settings
fix_locale() {
    echo "LC_ALL=en_US.UTF-8" | sudo tee -a /etc/environment
    echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
    echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.conf
    sudo locale-gen en_US.UTF-8
}

fix_time() {
    sudo pacman -S --noconfirm --needed ntp
    systemctl enable ntpd
    timedatectl set-ntp 1
}

bootloader_theme() {
    git clone https://github.com/ChrisTitusTech/Top-5-Bootloader-Themes
    cd Top-5-Bootloader-Themes
    sudo ./install.sh
}

nvchad_install() {
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    rm -rf "$HOME/.local/state/nvim/shada"
}

login_manager(){
    # Install lightdm 
    sudo systemctl disable lightdm
    # Install necessary packages
    sudo pacman -S --needed --noconfirm xorg xfce4 xfce4-goodies
    # Move .xinitrc to $HOME and make it executable
    cp -r "$current_dir/.xinitrc" "$HOME" 2>/dev/null
    # Create a symlink for .xinitrc to start x server
    ln -s $HOME/.config/X11/.xinitrc $HOME
    chmod +x "$HOME/.xinitrc"
}

geatures_app() {
  paru -S --noconfirm --needed wmctrl xdotool libinput-gestures gestures
  sudo gpasswd -a $USER input
  libinput-gestures-setup autostart
}
########## ---------- Ena# Function to build and install Luke's st terminal emulator
lukes_st_build() {
  local st_repo="https://github.com/LukeSmithxyz/st"
  local st_dir="st"

  # Clone the repository in a subshell
  (git clone "$st_repo" "$st_dir") || {
    echo "Error: Failed to clone the st repository."
    return 1
  }

  # Build and install st in a subshell
  (cd "$st_dir" && sudo make install) || {
    echo "Error: Failed to build and install st."
    return 1
  }

  # Successfully built and installed st
  echo "Luke's st terminal emulator has been built and installed successfully."
}

# bling MPD service ---------- ##########
music_player() {
    # Install mpd and mpc packages
    sudo pacman -S mpd mpc --noconfirm --needed

    # Remove existing mpd.conf
    sudo rm /etc/mpd.conf

    # Create mpd config directory and copy example config
    mkdir -p ~/.config/mpd
    cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf

    # Update mpd.conf using sed
    declare -A replacements=(
        ["#music_directory"]="music_directory"
        ["~/music"]="~/Music"
        ["#playlist_directory"]="playlist_directory"
        ["~/.mpd/playlists"]="~/.config/mpd/playlists"
        ["#db_file"]="db_file"
        ["~/.mpd/database"]="~/.config/mpd/database"
        ["#log_file"]="log_file"
        ["~/.mpd/log"]="~/.config/mpd/log"
        ["#pid_file"]="pid_file"
        ["~/.mpd/pid"]="~/.config/mpd/pid"
        ["#state_file"]="state_file"
        ["~/.mpd/state"]="~/.config/mpd/state"
        ["#sticker_file"]="sticker_file"
        ["~/.mpd/sticker"]="~/.config/mpd/sticker"
        ["#bind_to_address"]="bind_to_address"
        ["\"any\""]="\"127.0.0.1\""
        ["#port"]="port"
        ["#auto_update"]="auto_update"
        ["#follow_inside_symlinks"]="follow_inside_symlinks"
        ["~/.mpd/socket"]="~/.config/mpd/socket"
        ["#filesystem_charset"]="filesystem_charset"
    )

    for key in "${!replacements[@]}"; do
        sed -i "s/${key}/${replacements[$key]}/" ~/.config/mpd/mpd.conf
    done

    # Append additional audio_output config
    cat << EOF >> ~/.config/mpd/mpd.conf
audio_output {
    type  "pulse"
    name  "pulseaudio"
}

audio_output {
    type               "fifo"
    name               "Visualizer"
    path               "/tmp/mpd.fifo"
    format             "44100:16:2"
}
EOF

    # Create mpd playlists directory
    mkdir -p ~/.config/mpd/playlists

    # Enable and start mpd service
    systemctl --user enable --now mpd.service

    # Install ncmpcpp
    sudo pacman -S ncmpcpp --noconfirm --needed

    # Create ncmpcpp config directory and copy example config
    mkdir -p ~/.config/ncmpcpp
    cp /usr/share/doc/ncmpcpp/config ~/.config/ncmpcpp/config

    # Update ncmpcpp config using sed
    declare -A ncmpcpp_replacements=(
        ["#ncmpcpp_directory"]="ncmpcpp_directory"
        ["#lyrics_directory"]="lyrics_directory"
        ["#mpd_host"]="mpd_host"
        ["#mpd_port"]="mpd_port"
        ["#mpd_connection_timeout"]="mpd_connection_timeout"
        ["#mpd_music_dir = ~/music"]="mpd_music_dir = ~/Music"
        ["#mpd_crossfade_time"]="mpd_crossfade_time"
    )

    for key in "${!ncmpcpp_replacements[@]}"; do
        sed -i "s/${key}/${ncmpcpp_replacements[$key]}/" ~/.config/ncmpcpp/config
    done

    # Copy ncmpcpp bindings
    cp /usr/share/doc/ncmpcpp/bindings ~/.config/ncmpcpp/bindings

    # Enable and start mpd service
    systemctl --user enable mpd.service
    systemctl --user start mpd.service

    # Script completed
    printf "Done!!\n\n"
}

# Install and configure ZSH
to_zsh() {
    if [[ $SHELL != "/usr/bin/zsh" ]]; then
        echo "Changing shell to zsh, your root password is needed."
        chsh -s /usr/bin/zsh
    else
        echo "Your shell is already zsh"
    fi
}

spotify_themer() {
    # Install spicetify-cli package using paru and Spotify
    paru -S --noconfirm --needed spotify spicetify-cli

    # Define variables for paths
    spicetify_config="$HOME/.config/spicetify/config-xpui.ini"
    spicetify_themes_repo="https://github.com/spicetify/spicetify-themes.git"
    spicetify_themes_dest="$HOME/.config/spicetify/Themes"

    # Check if the spicetify config file exists before proceeding
    if [ ! -f "$spicetify_config" ]; then
        echo "Error: Spicetify config file not found at $spicetify_config. Run 'spicetify -c' to set it up."
        exit 1
    fi

    # Function to execute spicetify commands
    run_spicetify() {
        echo "Setting up Spicetify..."
        spicetify && \
        spicetify backup apply enable-devtool && \
        spicetify update
    }

    # Execute spicetify commands
    run_spicetify

    # Clone the spicetify-themes repository and apply the desired theme and color scheme
    echo "Cloning spicetify-themes repository..."
    git clone "$spicetify_themes_repo" "$HOME/Downloads/spicetify-themes" && \
    cp -r "$HOME/Downloads/spicetify-themes"/* "$spicetify_themes_dest" && \
    echo "Applying the Sleek theme and Psycho color scheme..." && \
    spicetify config current_theme Sleek && \
    spicetify config color_scheme Psycho && \
    spicetify apply

    echo "Spicetify setup is complete."
}

move_and_link_dotfiles() {
    # Create Old-backups directory if it doesn't exist
    mkdir -p "$HOME/Old-Backups"

    # Move .config folder files and create backups if needed
    mv -n "$HOME/.config"/* "$HOME/Old-backups/" 2>/dev/null

    # Move .fonts and .icons to $HOME
    cp -r "$current_dir/misc/.fonts" "$HOME" 2>/dev/null
    cp -r "$current_dir/misc/.icons" "$HOME" 2>/dev/null

    # Move local/bin folder files to $HOME/local/bin
    mkdir -p "$HOME/local/bin"
    cp -r "$current_dir/.local/bin"/* "$HOME/.local/bin" 2>/dev/null

    # Move .wallpaper to $HOME/.wallpaper
    mkdir -p "$HOME/.wallpaper"
    cp -r "$current_dir/misc/.wallpaper"/* "$HOME/.wallpaper" 2>/dev/null

    # Create symlinks for .conkyrc and .zshrc
    ln -sf "$HOME/.config/conky/.conkyrc" "$HOME"
    ln -sf "$HOME/.config/zsh/.zshrc" "$HOME"

    # Updates plocate database
    sudo updatedb
    # Updating font cache
    fc-cache -f
    # Updating bookmarks to the current user dir
    sed -i "s@file:///home/StealthIQ@file:///home/$USER@" ~/.config/gtk-3.0/bookmarks
}

# Welcome message and confirmation
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

# Log function to write to a log file
log_function() {
    local log_file="installation_log.txt"
    local current_function="$1"
    local action="$2"
    local status="$3"
    local log_message="[${current_function}]\n"
    
    if [[ -n "$action" ]]; then
        log_message+="Action: ${action}\n"
    fi
    
    if [[ -n "$status" ]]; then
        log_message+="Status: ${status}\n"
    fi

    echo -e "$log_message\n" >> "$log_file"
}

# Main function
main() {
    welcome_msg
#    fix_keyring_error
     lukes_st_build
     login_manager
#
    # log_function "fix_keyring_error" "Updating keyring" "Success"

    # base_pkg
    # log_function "base_pkg" "Installed base packages" "Success"

    # install_from_aur "$aurhelper"
    # log_function "install_from_aur" "Installing AUR helper" "Success"

#    install_packages "$aurhelper" "$packages_file"
    # inst_pkg
    # log_function "install_packages" "Installed packages from $packages_file" "Success"

     #move_and_link_dotfiles
    # log_function "move_and_link_dotfiles" "Moved and linked dotfiles" "Success"

    # nvchad_install
    # log_function "nvchad_install" "Installed NvChad for Neovim" "Success"

    # music_player
    # log_function "music_player" "Installed and configured MPD and ncmpcpp" "Success"

    # to_zsh
    # log_function "to_zsh" "Changed default shell to Zsh" "Success"
    
    # spotify_themer
#    bootloader_theme
    echo "${green}Installation completed successfully.${reset}"
    # log_function "main" "Script execution completed" "Success"
}

main

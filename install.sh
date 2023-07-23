#!/bin/sh

# Script to install dotfile for Arch Linux
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
packages_file="misc/packages.txt"
aurhelper="paru"
repobranch="master"
export TERM=ansi

### FUNCTIONS ###
installpkg() {
	pacman --noconfirm --needed -S "$1" >/dev/null 2>&1
}

error_s() {
	# Log to stderr and exit with failure.
	printf "${red}%s\n${reset}" "$1" >&2
	exit 1
}

nvchad() {
rm -rf /$HOME/.local/state/nvim/shada
}

welcome_msg() {
  clear

  printf "${cyan}Welcome to StealthIQ Arch Linux Setup"
  printf "${blue}This script will automatically install all the necessary pacakges, \nI use and make sure you get the exact same setup as me\n\n${reset}"
  
  read -p "Do you want to continue? (y/n): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "${green}Continuing with the script..."
      # Add your script commands here
  else
      clear
      echo "${red}Exiting the script."
      exit
  fi
}

install_pkg() {
    while read LINE; do paru -S --noconfirm --needed $LINE; done < ${packages_file}
}


# Start of the script 
welcome_msg
install_pkg




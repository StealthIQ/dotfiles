#!/bin/bash

# Get a list of installed packages that provide fonts
installed_packages=$(pacman -Qs '^ttf-' | awk '{print $1}')

# Loop through each installed package
for package in $installed_packages; do
  # Get a list of files installed by the package
  package_files=$(pacman -Qlq $package)

  # Loop through each file and check if it is a font file
  for file in $package_files; do
    if [[ $file == *.ttf || $file == *.otf ]]; then
      # Check if any application is currently using the font file
      if fc-list | grep -q "$file"; then
        echo "Font File: $file"
        echo "----------------------"
        break
      fi
    fi
  done
done

#! /bin/bash

# To get list of all pakages | pacman -Q | awk '{print $1}' > all-arch-packages.txt


# while read LINE; do paru -S --noconfirm --needed $LINE; done < all-arch-packages.txt
while read LINE; do paru -S --noconfirm --needed $LINE; done < base/pakages.txt


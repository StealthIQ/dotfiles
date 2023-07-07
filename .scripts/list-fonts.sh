#!/bin/bash

# Get the list of all fonts
fonts=$(fc-list | cut -d ':' -f 2 | cut -d ',' -f 1 | sort -u)

# Print the fonts
echo "Used Fonts:"
echo "-----------"
echo "$fonts"

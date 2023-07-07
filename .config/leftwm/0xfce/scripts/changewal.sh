#!/bin/bash
### Check if python-pywal is installed
if [ -x "$(command -v wal)" ]; then
  my_array=(/home/i_0xfce/Pictures/wal-consistant/*)
     wal -t -e -i ${my_array[$(( $RANDOM % ${#my_array[@]}))]} -a 80
else
  # Set background
  if [ -x "$(command -v feh)" ]; then
    feh --randomize --bg-fill /home/i_0xfce/Pictures/wal-consistant/*
  fi
fi

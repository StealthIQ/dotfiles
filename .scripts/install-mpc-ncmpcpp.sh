#!/bin/bash

# Install mpd and mpc
sudo pacman -S mpd mpc --noconfirm --needed

# Remove existing mpd.conf
sudo rm /etc/mpd.conf

# Create mpd configuration directory
mkdir -p ~/.config/mpd

# Copy default mpd configuration file
cp /usr/share/doc/mpd/mpdconf.example ~/.config/mpd/mpd.conf

# Modify mpd configuration options
sed -i 's|#music_directory.*|music_directory    "~/Music"|' ~/.config/mpd/mpd.conf
sed -i 's|#playlist_directory.*|playlist_directory    "~/.config/mpd/playlists"|' ~/.config/mpd/mpd.conf
sed -i 's|#db_file.*|db_file    "~/.config/mpd/database"|' ~/.config/mpd/mpd.conf
sed -i 's|#log_file.*|log_file    "~/.config/mpd/log"|' ~/.config/mpd/mpd.conf
sed -i 's|#pid_file.*|pid_file    "~/.config/mpd/pid"|' ~/.config/mpd/mpd.conf
sed -i 's|#state_file.*|state_file    "~/.config/mpd/state"|' ~/.config/mpd/mpd.conf
sed -i 's|#sticker_file.*|sticker_file    "~/.config/mpd/sticker.sql"|' ~/.config/mpd/mpd.conf
sed -i 's|#bind_to_address.*|bind_to_address    "127.0.0.1"|' ~/.config/mpd/mpd.conf
sed -i 's|#port.*|port    "6600"|' ~/.config/mpd/mpd.conf
sed -i 's|#auto_update.*|auto_update    "yes"|' ~/.config/mpd/mpd.conf
sed -i 's|#follow_inside_symlinks.*|follow_inside_symlinks    "yes"|' ~/.config/mpd/mpd.conf
sed -i 's|#filesystem_charset.*|filesystem_charset    "UTF-8"|' ~/.config/mpd/mpd.conf

# Add audio output configuration
echo 'audio_output {
    type  "pulse"
    name  "pulseaudio"
}

audio_output {
    type               "fifo"
    name               "Visualizer"
    path               "/tmp/mpd.fifo"
    format             "44100:16:2"
}' >> ~/.config/mpd/mpd.conf

# Create mpd playlists directory
mkdir -p ~/.config/mpd/playlists

# Enable and start mpd service
systemctl --user enable --now mpd.service

##############################################################################

# Install ncmpcpp
sudo pacman -S ncmpcpp --noconfirm --needed

# Create ncmpcpp configuration directory
mkdir -p ~/.config/ncmpcpp

# Copy default ncmpcpp configuration file
cp /usr/share/doc/ncmpcpp/config ~/.config/ncmpcpp/config

# Modify ncmpcpp configuration options
sed -i 's|#ncmpcpp_directory.*|ncmpcpp_directory = ~/.config/ncmpcpp|' ~/.config/ncmpcpp/config
sed -i 's|#lyrics_directory.*|lyrics_directory = ~/.lyrics|' ~/.config/ncmpcpp/config
sed -i 's|#mpd_host.*|mpd_host = "localhost"|' ~/.config/ncmpcpp/config
sed -i 's|#mpd_port.*|mpd_port = "6600"|' ~/.config/ncmpcpp/config
sed -i 's|#mpd_connection_timeout.*|mpd_connection_timeout = 5|' ~/.config/ncmpcpp/config
sed -i 's|#mpd_music_dir.*|mpd_music_dir = ~/Music|' ~/.config/ncmpcpp/config
sed -i 's|#mpd_crossfade_time.*|mpd_crossfade_time = 5|' ~/.config/ncmpcpp/config

# Copy ncmpcpp keybindings
cp /usr/share/doc/ncmpcpp/bindings ~/.config/ncmpcpp/bindings

#!/usr/bin/env bash

# Color files Polybar
polybar_config="$HOME/.config/polybar/colors.ini"
# Color files Overall
xresources_config="$HOME/.config/Xresources/Xcolors"
kitty_config="$HOME/.config/kitty/current-theme.conf"
conky_config="$HOME/.config/conky/rings-v1.2.1.lua"
cava_config="$HOME/.config/cava/config"
glava_config="$HOME/.config/glava/bars.glsl"
bashtop_config="$HOME/.config/bashtop/themes/embark.theme"
discord_config="$HOME/.config/BetterDiscord/themes/ClearVision_v6.theme.css"
dmenu_config="$HOME/.config/sxhkd/scripts/dmenu.sh"
wallpapersDir="$HOME/.wallpapers/"
rofi_config="$HOME/.config/rofi/colors/custom.rasi"
cache_dir="$HOME/.cache/walcache"

# Gets random wallpaper
get_random_wallpaper() {
    local randomWallpaper=$(find "$wallpapersDir" -type f \( -name "*.jpg" -o -name "*.png" \) -print | shuf -n 1)
    echo "$randomWallpaper"
}

# Cache color palette for a wallpaper
cache_wallpaper_colors() {
    local wallpaper="$1"
    mkdir -p "$cache_dir"
    local cache_file="$cache_dir/$(basename "$wallpaper").cache"

    if [[ ! -f "$cache_file" ]]; then
        wal -i "$wallpaper"
        local exit_code=$?

        if [[ $exit_code -ne 0 ]]; then
            echo "Error: Imagemagick couldn't generate a 16 color palette. Deleting the wallpaper..."
            rm "$wallpaper"
            exit 1
        fi

        cp "$HOME/.cache/wal/colors.sh" "$cache_file"
    fi
    . "$cache_file"
}

# Change colors for Polybar
change_theme_polybar() {
    # polybar
    local sed_commands=()
    sed_commands+=(-e "s/background = #.*/background = ${BG}/g")
    sed_commands+=(-i "/background-alt = #8C/c background-alt = #8C${BGA}" "$polybar_config")
    sed_commands+=(-e "s/foreground = #.*/foreground = ${FG}/g")
    sed_commands+=(-e "s/themes = #.*/themes = $SH14/g" "$polybar_config")
    sed "${sed_commands[@]}"

    # rofi
    cat > "$rofi_config" <<- EOF
/* colors */

* {
    background:     ${BG}FF;
    background-alt: ${SH0}FF;
    foreground:     #808080FF;
    selected:       ${SH14}FF;
    active:         ${SH8}FF;
    urgent:         ${SH8}FF;
}
EOF

    bash "$HOME/.config/polybar/launch.sh" &

    # Source the cached color palette
    cache_wallpaper_colors "$randomWallpaper"
}

# Change colors for other applications
change_theme_overall() {
    # Changes conky color
    sed -i "/current1 = 0x/c current1 = 0x${CONKY}" "$conky_config"

    # Changes cava gradient
    local cava_colors=(
        "${SH14}" "${SH13}" "${SH12}" "${SH11}"
        "${SH4}" "${SH3}" "${SH2}" "${SH1}"
    )
    for ((i = 0; i < ${#cava_colors[@]}; i++)); do
        sed -i "/gradient_color_$((i + 1)) = '/c gradient_color_$((i + 1)) = '${cava_colors[i]}'" "$cava_config"
    done
    # reloads cava without needed to close it
    pkill -USR1 cava

    # Changes Glava theme
    sed -i "/#define COLOR (#/c #define COLOR (${SH14} * GRADIENT)" "$glava_config"

    # Dmenu 
    cat > "$dmenu_config" <<- EOF
#!/bin/bash

# Demenu run
dmenu_run -i -nb '${BG}' -nf '${SH14}' -sb '${SH14}' -sf '${SH0}' -fn 'NotoMonoRegular:bold:pixelsize=14'
EOF

    # Changes Kitty theme
    cat > "$kitty_config" <<- EOFE
background            ${BG}
foreground            ${FG}
cursorColor           ${SH14}
selection_background  ${SH1}
color0                ${SH0}
color1                ${SH1}
color2                ${SH2}
color3                ${SH3}
color4                ${SH14}
color5                ${SH5}
color6                ${FG}
color7                ${FG}
color8                ${SH8}
color9                ${SH9}
color10               ${SH10}
color11               ${SH12}
color12               ${SH12}
color13               ${SH13}
color14               ${FG}
color15               ${FG}
selection_foreground  ${SH0}
EOFE

    # Changes St theme
    cat > "$xresources_config" <<- EOF
! Colors
*.background: ${BG}
*.foreground: ${FG}
*.cursorColor: ${SH14}
*.selection_background: ${SH1}
*.color0: ${SH0}
*.color1: ${SH1}
*.color2: ${SH2}
*.color3: ${SH3}
*.color4: ${SH14}
*.color5: ${SH5}
*.color6: ${FG}
*.color7: ${FG}
*.color8: ${SH8}
*.color9: ${SH9}
*.color10: ${SH10}
*.color11: ${SH12}
*.color12: ${SH12}
*.color13: ${SH13}
*.color14: ${FG}
*.color15: ${FG}
*.selection_foreground: ${SH0}
EOF

    # Changes Bspwm Border Color
    bspc config normal_border_color    "${SH1}"
    bspc config active_border_color     "${SH13}"
    bspc config focused_border_color    "${SH14}"
    bspc config presel_feedback_color   "${SH2}"

    xrdb merge "$HOME/.config/Xresources/Xresources"

    # Source the cached color palette
    cache_wallpaper_colors "$randomWallpaper"
}

# Extracting Colors From Pywal
if [[ $1 = "--theme" ]]; then
    # Generating colors according to the wallpaper
    randomWallpaper=$(get_random_wallpaper)

    # Source the cached color palette or generate if not cached
    cache_wallpaper_colors "$randomWallpaper"

    # Source the pywal color file
    . "$HOME/.cache/wal/colors.sh"
    BG=$(printf "%s\n" "$color0")
    BGA=$(printf $color0 | cut -c2-)
    FG=$(printf "%s\n" "$color15")
    FGA=$(printf "%s\n" "$color7")
    SH0=$(printf "%s\n" "$color0")
    SH1=$(printf "%s\n" "$color1")
    SH2=$(printf "%s\n" "$color2")
    SH3=$(printf "%s\n" "$color3")
    SH4=$(printf "%s\n" "$color4")
    SH5=$(printf "%s\n" "$color5")
    SH6=$(printf "%s\n" "$color6")
    SH7=$(printf "%s\n" "$color7")
    SH8=$(printf "%s\n" "$color8")
    SH9=$(printf "%s\n" "$color9")
    SH10=$(printf "%s\n" "$color10")
    SH11=$(printf "%s\n" "$color11")
    SH12=$(printf "%s\n" "$color12")
    SH13=$(printf "%s\n" "$color13")
    SH14=$(printf "%s\n" "$color14")
    SH15=$(printf "%s\n" "$color15")

    # Conky Color
    CONKY=$(printf "$color14" | cut -c2-)
    
    change_theme_overall
    change_theme_polybar
    echo $bg
    printf "\n Successfully changed the theme!! \n"
else
    echo "./pywal.sh --theme"
    echo -e "\n Usage : ./pywal.sh --theme \n"
fi

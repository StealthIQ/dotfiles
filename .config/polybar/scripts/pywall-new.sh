#!/usr/bin/env bash

# File paths
polybarColorsFile="$HOME/.config/polybar/colors.ini"
xresourcesFile="$HOME/.config/Xresources/Xcolors"
kittyThemeFile="$HOME/.config/kitty/current-theme.conf"
conkyConfigFile="$HOME/.config/conky/rings-v1.2.1.lua"
cavaConfigFile="$HOME/.config/cava/config"
glavaConfigFile="$HOME/.config/glava/bars.glsl"
bashtopThemeFile="$HOME/.config/bashtop/themes/embark.theme"
discordThemeFile="$HOME/.config/BetterDiscord/themes/ClearVision_v6.theme.css"
dmenuScriptFile="$HOME/.config/sxhkd/scripts/dmenu.sh"
wallpapersDir="$HOME/.wallpapers/"

# Gets random wallpaper
randomWallpaper=$(find "$wallpapersDir" -type f \( -name "*.jpg" -o -name "*.png" \) -print | shuf -n 1)

# Get colors using pywal
getColorsFromPywal() {
    wal -t -i "$randomWallpaper" -a 80
}

# Change Polybar theme colors
changePolybarTheme() {
    sed -i -e "s/background = #.*/background = ${background}/g" \
           -e "/background-alt = #8C/c background-alt = #8C${backgroundAlt}" \
           -e "s/foreground = #.*/foreground = ${foreground}/g" \
           -e "s/themes = .*$/themes = #${mainTheme}/g" "$polybarColorsFile" 
    polybar-msg cmd restart
    echo "Noiec-----------------"
    
}

# Change overall theme colors
changeOverallTheme() {
    tmpFile=$(mktemp)

    sed -e "/current1 = 0x/c current1 = 0x${mainTheme}" "$conkyConfigFile" > "$tmpFile"
    mv "$tmpFile" "$conkyConfigFile"

    sed -e "s/BG=#.*/BG=${background}/g; \
            s/FG=#.*/FG=${themeSecondary}/g" "$dmenuScriptFile" > "$tmpFile"
    mv "$tmpFile" "$dmenuScriptFile"

    sed -e "/gradient_color_1 = '/c gradient_color_1 = '${themePrimary}'" \
        -e "/gradient_color_2 = '/c gradient_color_2 = '${themeSecondary}'" \
        -e "/gradient_color_3 = '/c gradient_color_3 = '${themeTertiary}'" \
        -e "/gradient_color_4 = '/c gradient_color_4 = '${themeQuaternary}'" \
        -e "/gradient_color_5 = '/c gradient_color_5 = '${themeQuinary}'" \
        -e "/gradient_color_6 = '/c gradient_color_6 = '${themeSenary}'" \
        -e "/gradient_color_7 = '/c gradient_color_7 = '${themeSeptenary}'" \
        -e "/gradient_color_8 = '/c gradient_color_8 = '${themeOctonary}'" "$cavaConfigFile" > "$tmpFile"
    mv "$tmpFile" "$cavaConfigFile"

    sed -e "/#define COLOR (#/c #define COLOR (${themeSecondary} * GRADIENT)" "$glavaConfigFile" > "$tmpFile"
    mv "$tmpFile" "$glavaConfigFile"

    cat > "$kittyThemeFile" <<- EOF
background            ${background}
foreground            ${foreground}
cursorColor           ${themeSecondary}
selection_background  ${themePrimary}
color0                ${themePrimary}
color1                ${themeSecondary}
color2                ${themeTertiary}
color3                ${themeQuaternary}
color4                ${themeSecondary}
color5                ${themeQuinary}
color6                ${foreground}
color7                ${foreground}
color8                ${themeSenary}
color9                ${themeSeptenary}
color10               ${themeOctonary}
color11               ${themeTertiary}
color12               ${themeTertiary}
color13               ${themeQuaternary}
color14               ${foreground}
color15               ${foreground}
selection_foreground  ${themePrimary}
EOF

    cat > "$xresourcesFile" <<- EOF
! Colors
*.background: ${background}
*.foreground: ${foreground}
*.cursorColor: ${themeSecondary}
*.selection_background: ${themePrimary}
*.color0: ${themePrimary}
*.color1: ${themeSecondary}
*.color2: ${themeTertiary}
*.color3: ${themeQuaternary}
*.color4: ${themeSecondary}
*.color5: ${themeQuinary}
*.color6: ${foreground}
*.color7: ${foreground}
*.color8: ${themeSenary}
*.color9: ${themeSeptenary}
*.color10: ${themeOctonary}
*.color11: ${themeTertiary}
*.color12: ${themeTertiary}
*.color13: ${themeQuaternary}
*.color14: ${foreground}
*.color15: ${foreground}
*.selection_foreground: ${themePrimary}
EOF

    bspc config normal_border_color    "${themePrimary}"
    bspc config active_border_color     "${themeQuaternary}"
    bspc config focused_border_color    "${themeSecondary}"
    bspc config presel_feedback_color   "${themeTertiary}"

    xrdb merge ~/.config/Xresources/Xresources
}

# Extract colors from Pywal and apply the theme
if [[ $1 = "--theme" ]]; then
    getColorsFromPywal "$1"

    source "$HOME/.cache/wal/colors.sh"
    background=$color0
    backgroundAlt=${color0:1}
    foreground=$color15
    foregroundAlt=$color7
    themePrimary=$color0
    themeSecondary=$color1
    themeTertiary=$color2
    themeQuaternary=$color3
    themeQuinary=$color4
    themeSenary=$color5
    themeSeptenary=$color6
    themeOctonary=$color7
    mainTheme=${color14:1}

    changePolybarTheme
    changeOverallTheme
    echo "$background"
    printf "\nSuccessfully changed the theme!\n"
else
    echo "./pywal.sh --theme"
    echo -e "\nUsage: ./pywal.sh --theme\n"
fi

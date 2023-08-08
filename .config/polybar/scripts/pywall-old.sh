#!/usr/bin/env bash

# Color files Polybar
Polybar="$HOME/.config/polybar/colors.ini"
# Color files Overall
Xcolor="$HOME/.config/Xresources/Xcolors"
Kitty="$HOME/.config/kitty/current-theme.conf"
Conky="$HOME/.config/conky/rings-v1.2.1.lua"
Cava="$HOME/.config/cava/config"
Glava="$HOME/.config/glava/bars.glsl"
Bashtop="$HOME/.config/bashtop/themes/embark.theme"
Discord="$HOME/.config/BetterDiscord/themes/ClearVision_v6.theme.css"
Dmenu="$HOME/.config/sxhkd/scripts/dmenu.sh"
wallpapersDir="$HOME/.wallpapers/"
Rolfi_polybar_2="$HOME/.config/rofi/colors/custom.rasi"

# Gets random wallpaper
randomWallpaper=$(find "$wallpapersDir" -type f \( -name "*.jpg" -o -name "*.png" \) -print | shuf -n 1)

# Get colors
pywal_get() {
    wal -t -i "$randomWallpaper" -a 80
}

# Change colors
change_theme_polybar() {

	# polybar
  printf "$BG"
  echo"BG = $BG"
	sed -i -e "s/background = #.*/background = ${BG}/g" $Polybar
  sed -i "/background-alt = #8C/c background-alt = #8C${BGA}" $Polybar
  sed -i -e "s/foreground = #.*/foreground = ${FG}/g" $Polybar
	sed -i -e "s/themes = #.*/themes = $SH14/g" $Polybar
	
	# rofi
	cat > $Rolfi_polybar_2 <<- EOF
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
	bash ~/.config/polybar/launch.sh &
  }


change_theme_overall() {

      # Changes conky color
      sed -i "/current1 = 0x/c current1 = 0x${CONKY}" $Conky

      # Changes cava gradient
      sed -i "/gradient_color_1 = '/c gradient_color_1 = '${SH14}'" $Cava
      sed -i "/gradient_color_2 = '/c gradient_color_2 = '${SH13}'" $Cava
      sed -i "/gradient_color_3 = '/c gradient_color_3 = '${SH12}'" $Cava
      sed -i "/gradient_color_4 = '/c gradient_color_4 = '${SH11}'" $Cava
      sed -i "/gradient_color_5 = '/c gradient_color_5 = '${SH4}'" $Cava
      sed -i "/gradient_color_6 = '/c gradient_color_6 = '${SH3}'" $Cava
      sed -i "/gradient_color_7 = '/c gradient_color_7 = '${SH2}'" $Cava
      sed -i "/gradient_color_8 = '/c gradient_color_8 = '${SH1}'" $Cava
      # reloads cava without needed to close it
      pkill -USR1 cava
  
      # Changes Glava theme
      sed -i "/#define COLOR (#/c #define COLOR (${SH14} * GRADIENT)" $Glava

      # Dmenu 
      cat > $Dmenu <<- EOF
#!/bin/bash

# Demenu run
dmenu_run -i -nb '${BG}' -nf '${SH14}' -sb '${SH14}' -sf '${SH0}' -fn 'NotoMonoRegular:bold:pixelsize=14'
}
EOF

      # Changes Kitty theme
      cat > $Kitty <<- EOFE
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
      cat > $Xcolor <<- EOF
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

	xrdb merge ~/.config/Xresources/Xresources
}


# Extracting Colors From Pywall
if [[ $1 = "--theme" ]]; then

    # Generating colors accoring to the wallpaper
    pywal_get "$1"

    # Source the pywal color file
    . "$HOME/.cache/wal/colors.sh"
    BG=`printf "%s\n" "$color0"`
    BGA=`printf $color0 | cut -c2-`
    FG=`printf "%s\n" "$color15"`
    FGA=`printf "%s\n" "$color7"`
    SH0=`printf "%s\n" "$color0"`
    SH1=`printf "%s\n" "$color1"`
    SH2=`printf "%s\n" "$color2"`
    SH3=`printf "%s\n" "$color3"`
    SH4=`printf "%s\n" "$color4"`
    SH5=`printf "%s\n" "$color5"`
    SH6=`printf "%s\n" "$color6"`
    SH7=`printf "%s\n" "$color7"`
    SH8=`printf "%s\n" "$color8"`
    SH9=`printf "%s\n" "$color9"`
    SH10=`printf "%s\n" "$color10"`
    SH11=`printf "%s\n" "$color11"`
    SH12=`printf "%s\n" "$color12"`
    SH13=`printf "%s\n" "$color13"`
    SH14=`printf "%s\n" "$color14"`
    SH15=`printf "%s\n" "$color15"`

    # Conky Color
    CONKY=`printf $color14 | cut -c2-`
    
    change_theme_polybar
    change_theme_overall
    echo $bg
    printf "\n Successfully changed the theme!! \n"
else
    echo "./pywal.sh --theme"echo -e "\n Usage : ./pywal.sh --theme \n"

fi

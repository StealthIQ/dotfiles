#!/usr/bin/env bash

# Color files Polybar
Polybar="$HOME/.config/polybar/colors.ini"
Rolfi="$HOME/.config/polybar/scripts/rofi/colors.rasi"
Rolfi-2="$HOME/.config/rofi/launchers/colorful/colors.rasi"
# RFILE="$HOME/.config/polybar/cuts/scripts/rofi/colors.rasi"

# Color files Overall
Xcolor="$HOME/.Xresources.d/.Xcolors"
Kitty="$HOME/.config/kitty/current-theme.conf"
Conky="$HOME/.config/conky/rings-v1.2.1.lua"
Cava="$HOME/.config/cava/config"
Glava="$HOME/.config/glava/bars.glsl"
Bashtop="$HOME/.config/bashtop/themes/embark.theme"
Discord="$HOME/.config/BetterDiscord/themes/ClearVision_v6.theme.css"
Dmenu="$HOME/.config/sxhkd/scripts/dmenu.sh"

BG="0a0a0a"
FG="f5f5f5"

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = #${BG}/g" $Polybar
	sed -i -e "s/background-alt = #.*/background-alt = #8C${BG}/g" $Polybar
	sed -i -e "s/foreground = #.*/foreground = #${FG}/g" $Polybar
	sed -i -e "s/foreground-alt = #.*/foreground-alt = #33${FG}/g" $Polybar
	sed -i -e "s/themes = #.*/themes = $AC/g" $Polybar
	
        # Changes St theme
        cat > $Xcolor <<- EOF
! Colors
*.cursorColor: ${AC}
*.selection_background: #131313
*.selection_foreground: #FFFFFF
*.foreground:  #d6dbe5
*.background:  #131313
*.color0:      #1f1f1f
*.color8:      #d6dbe5
*.color1:      #f81118
*.color9:      #de352e
*.color2:      #2dc55e
*.color10:     #1dd361
*.color3:      #ecba0f
*.color11:     #f3bd09
*.color4:      ${AC}
*.color12:     #1081d6
*.color5:      #4e5ab7
*.color13:     #5350b9
*.color6:      #1081d6
*.color14:     #0f7ddb
*.color7:      #d6dbe5
*.color15:     #ffffff
	EOF
        xrdb merge ~/.Xresources &


    #Conky colors
    sed -i "/current1 = 0x/c current1 = ${ACE}" $Conky

	# rofi
	cat > $Rolfi <<- EOF
	/* colors */

	* {
	  al:   #00000000;
	  bg:   #${BG}BF;
	  bga:  #${BG}FF;
	  fg:   #${FG}FF;
	  ac:   ${AC}FF;
	  se:   ${AC}1A;
	}
	EOF
	       
    #Bspwm Border Color
    bspc config normal_border_color    "${BG}"
    bspc config active_border_color     "${AC}"
    bspc config focused_border_color    "${AC}"

	polybar-msg cmd restart
}

if  [[ $1 = "--amber" ]]; then
	AC="#ffb300"
	ACE="0xffb300"
	change_color
elif  [[ $1 = "--blue" ]]; then
	AC="#1e88e5"
	ACE="0x1e88e5"
	change_color
elif  [[ $1 = "--blue-gray" ]]; then
	AC="#546e7a"
	ACE="0x546e7a"
	change_color
elif  [[ $1 = "--brown" ]]; then
	AC="#6d4c41"
	ACE="0x6d4c41"
	change_color
elif  [[ $1 = "--cyan" ]]; then
	AC="#00acc1"
	ACE="0x00acc1"
	change_color
elif  [[ $1 = "--deep-orange" ]]; then
	AC="#f4511e"
	ACE="0xf4511e"
	change_color
elif  [[ $1 = "--deep-purple" ]]; then
	AC="#5e35b1"
	ACE="0x5e35b1"
	change_color
elif  [[ $1 = "--green" ]]; then
	AC="#43a047"
	ACE="0x43a047"
	change_color
elif  [[ $1 = "--gray" ]]; then
	AC="#757575"
	ACE="0x757575"
	change_color
elif  [[ $1 = "--indigo" ]]; then
	AC="#3949ab"
	ACE="0x3949ab"
	change_color
elif  [[ $1 = "--light-blue" ]]; then
	AC="#039be5"
	ACE="0x039be5"
	change_color
elif  [[ $1 = "--light-green" ]]; then
	AC="#3ad80d"
	ACE="0x3ad80d"
	change_color
elif  [[ $1 = "--lime" ]]; then
	AC="#c0ca33"
	ACE="0xc0ca33"
	change_color
elif  [[ $1 = "--orange" ]]; then
	AC="#fb8c00"
	ACE="0xfb8c00"
	change_color
elif  [[ $1 = "--pink" ]]; then
	AC="#d81b60"
	ACE="0xd81b60"
	change_color
elif  [[ $1 = "--purple" ]]; then
	AC="#8e24aa"
	ACE="0x8e24aa"
	change_color
elif  [[ $1 = "--red" ]]; then
	AC="#e53935"
	ACE="0xe53935"
	change_color
elif  [[ $1 = "--teal" ]]; then
	AC="#00897b"
	ACE="0x00897b"
	change_color
elif  [[ $1 = "--yellow" ]]; then
	AC="#fdd835"
	ACE="0xfdd835"
	change_color
else
	cat <<- _EOF_
	--amber	--blue		--blue-gray	--brown
	--cyan	--deep-orange	--deep-purple	--green
	--gray	--indigo	--light-blue	--light-green
	--lime	--orange	--pink		--purple
	--red	--teal		--yellow
	_EOF_
fi

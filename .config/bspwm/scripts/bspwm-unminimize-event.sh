#! /bin/sh
xev -root | grep '(_NET_ACTIVE_WINDOW)' -B 1 --line-buffered | \
	grep '^ClientMessage' --line-buffered | sed -u -e 's/^.*window //; s/,//' | \
	while read w; do \
		if [ -n "$(bspc query -N -n $w.hidden)" ]; then \
			bspc node "$w" -g hidden=off
			bspc node $w.fullscreen -t tiled
			bspc node $w -l normal
			bspc node -a $w
		fi
	done

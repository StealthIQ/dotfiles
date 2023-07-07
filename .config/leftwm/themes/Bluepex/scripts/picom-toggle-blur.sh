#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	echo 
	killall picom
else
	echo 
	picom --experimental-backends -b
fi
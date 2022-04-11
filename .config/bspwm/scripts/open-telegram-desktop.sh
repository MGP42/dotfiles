#!/usr/bin/bash
for x in $(bspc query -N); do 
	if [ "$(xprop -id $x | grep telegram)" != "" ]; then
		bspc node $x -d $(bspc query -D -d)
	fi
done
telegram-desktop

#!/bin/bash
# i3lock-color

# COLOR
color=ffffff
color_alert=aa0000
color_outline=000000
color_alert_outline=000000

#Background
image=$(jq -r '.wallpaper' ~/.cache/wal/colors.json)

#BAR
transparency=78

# SIZE AND SPACE
size=$(($(xrandr | grep -oP '\d{3,}x\d{3,}' | cut -d 'x' -f 2 | head -n 1)/29)) # Screen height / 29
space=$(awk "BEGIN{printf \"%i \n\",$size/2}")	# Size / 2
outline_width=1

i3lock\
	`#BACKGROUND`\
		-c 000000 `#Background Color`\
		-i $image\
		-F		`#Fill`\
	`#TIME SETTINGS`\
		--time-color=$color\
		--time-size=$((size*4))\
		--time-pos="x+$space:y+$((size*4))"\
		--time-align=1\
		--timeoutline-color=$color_outline\
		--timeoutline-width=$outline_width \
	`#DATE SETTINGS`\
		--date-str="%a %d. %B"\
		--date-color=$color\
		--date-size=$((size*2))\
		--date-pos="x+$space:y+$((size*6+space*1))"\
		--date-align=1\
		--dateoutline-color=$color_outline\
		--dateoutline-width=$outline_width\
	`#WRONMG SETTINGS`\
		--wrong-color=$color_alert\
		--wrong-size=$((size*2))\
		--wrong-pos="ix:iy-$((space*2))"\
		--wrongoutline-color=$color_alert_outline\
		--wrongoutline-width=$outline_width\
	`#VERIFICATION SETTINGS`\
		--verif-color=$color\
		--verif-size=$((size*2))\
		--verifoutline-color=$color_outline\
		--verifoutline-width=$outline_width\
	`#MODIFICATION SETTINGS`\
		--modif-color=$color\
		--modif-size=$size\
		--modif-pos="ix:iy+$space"\
		--modifoutline-color=$color_outline\
		--modifieroutline-width=$outline_width\
	`#BAR SETTINGS`\
		--bar-indicator \
		--bar-color=00000000\
		--bar-pos="x:y"\
		--ringver-color=$color$transparency\
		--ringwrong-color=$color_alert$transparency\
		--bshl-color=$(echo $color | fold -w2 | while read -r hex; do printf "%02d" "$(( 0x$hex / 8 ))"; done | tr -d '\n'; echo)\
		--keyhl-color=$color$transparency\
	`#CMD SETTINGS`\
		--custom-key-commands \
		--cmd-volume-up="amixer set Master 650+ unmute"\
		--cmd-volume-down="amixer set Master 650- unmute"\
		--cmd-audio-mute="amixer set Master toggle"\
	`#EXTRA SETTINGS`\
		-k		`#activate Clock`\
		-e		`#ignore empty password`\

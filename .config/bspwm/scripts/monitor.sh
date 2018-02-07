for i in $(xrandr | grep -o "^.* connected" | sed "s/ connected//"); do
	bspc monitor $i -d I II III IV V VI VII VIII IX X
done

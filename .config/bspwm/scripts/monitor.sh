### Remove Desktops from none existing Monitors
for i in $(bspc query -M --names); do
        if [ "" != "$(xrandr | grep -w $i | grep disconnected)" ];then
                bspc desktop -f $i:focused
                bspc monitor --remove
		bspc desktop -f ^1:focused
        fi
done

### Set Desktops of exisiting Monitors
for i in $(xrandr | grep -o "^.* connected" | sed "s/ connected//"); do
	bspc monitor $i -d I II III IV V VI VII VIII IX X
done

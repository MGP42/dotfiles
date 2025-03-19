symbol=$1
source ~/.cache/wal/colors-polybar

color_active=$main1_bg
color_inactive=$info1_bg
bgNoAlpha=$(echo $background | cut -c 1,4-)

monitor=$(bspc query -M -m $MONITOR --names)
monitor="%{A1:bash ~/.config/bspwm/scripts/monitor-activate.sh:}%{A2:bash ~/.config/bspwm/scripts/monitor.sh:}%{A3:bash ~/.config/bspwm/scripts/polybar_launch.sh:}$monitor%{A}%{A}%{A}"

monitor="\%\{F$bgNoAlpha\}\%\{B$color_active\}$symbol\%\{F$foreground\} $monitor \%\{F$color_active\}\%\{B$color_inactive\}$symbol\%\{F$foreground\}"

start="\%\{F$background\}\%\{B$color_inactive\}$symbol\%\{F$foreground\} "								# start of the desktop list
end=" \%\{F$color_inactive\}\%\{B$background\}$symbol\%\{F$foreground\}"									# end of the desktop list
end="\%\{F$color_inactive\}\%\{B$background\}$symbol\%\{F$foreground\}"
active_start="\%\{F$color_inactive\}\%\{B$color_active\}$symbol\%\{F$foreground\} "				# start of the active desktop
active_end=" \%\{F$color_active\}\%\{B$color_inactive\}$symbol\%\{F$foreground\}"					# end of the active desktop

# get bspwm data per desktop
getData() {
		all=$(bspc query -D -m --names)
		if [ $MONITOR == $(bspc query -M -m --names) ]; then	# only update if the monitor is the current monitor
			active=$(bspc query -D -d focused --names)
		fi
		occupied=$(bspc query -D -m $MONITOR --names -d .occupied )
		out=""
}

# return bspwm data
returnData() {
		for desktop in $all; do
        if echo "$active $occupied" | grep -qw "$desktop"; then
            out="$out\n$desktop"
        fi
    done

		echo -e "$out"  | awk -v active="$active" \
        -v active_start="$active_start" \
        -v active_end="$active_end" \
        -v start="$start" \
        -v end="$end" \
				-v monitor="$monitor" \
    'BEGIN {
        printf "%s", monitor
    }{
        if ($0 == active)
            printf "%s%s%s", active_start, $0, active_end;
				else if ($0!="")
            printf " %s%s%s%s%s ","%{A1:bspc desktop -f ", $0, ":}", $0, "%{A}";
    }
    END {
        print end
    }'
}
getData
active=$(bspc query -D -m $MONITOR -d .active --names)		# get active desktop of inactive monitors
returnData

bspc subscribe | while read -r _; do
	getData
	returnData
done

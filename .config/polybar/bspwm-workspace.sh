symbol=$1
source ~/.cache/wal/colors.sh

color_active=$color2
color_inactive=$color1

monitor=$(bspc query -M -m --names)
monitor="%{A1:bash ~/.config/bspwm/scripts/monitor-activate.sh:}%{A2:bash ~/.config/bspwm/         scripts/monitor.sh:}%{A3:bash ~/.config/bspwm/scripts/polybar_launch.sh:}$monitor%{A}%{A}%{A}"

monitor="\%\{F$background\}\%\{B$color_active\}$symbol\%\{F$foreground\} $monitor \%\{F$color_active\}\%\{B$color_inactive\}$symbol\%\{F$foreground\}"

start="\%\{F$background\}\%\{B$color_inactive\}$symbol\%\{F$foreground\} "
end="\%\{F$color_inactive\}\%\{B$background\}$symbol\%\{F$foreground\}"
active_start="\%\{F$color_inactive\}\%\{B$color_active\}$symbol\%\{F$foreground\} "
active_end=" \%\{F$color_active\}\%\{B$color_inactive\}$symbol\%\{F$foreground\}"

desktops() {
		all=$(bspc query -D -m --names)
    active=$(bspc query -D -d focused --names)
		occupied=$(bspc query -D -m $MONITOR --names -d .occupied )
		out=""

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

desktops
bspc subscribe desktop | while read -r _; do
    desktops
done

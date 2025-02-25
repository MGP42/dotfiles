symbol=$1
symbol=""
source ~/.cache/wal/colors.sh

color_active=$color5
color_inactive=$color2

start="\%\{F$background\}\%\{B$color_inactive\}$symbol\%\{F$foreground\} "
end="\%\{F$color_inactive\}\%\{B$background\}$symbol\%\{F$foreground\}"
active_start="\%\{F$color_inactive\}\%\{B$color_active\}$symbol\%\{F$foreground\} "
active_end=" \%\{F$color_active\}\%\{B$color_inactive\}$symbol\%\{F$foreground\}"
desktops() {
    active=$(bspc query -D -d focused --names)
    occupied=$(bspc query -D -d .occupied --names)

    echo -e "$occupied\n$active" | sort -u | awk -v active="$active" \
        -v active_start="$active_start" \
        -v active_end="$active_end" \
        -v start="$start" \
        -v end="$end" \
    'BEGIN {
        printf "%s", start
    }{
        if ($0 == active)
            printf "%s%s%s ", active_start, $0, active_end;
        else
            printf "%s ", $0
    }
    END {
        print end
    }'
}

desktops
bspc subscribe desktop | while read -r _; do
    desktops
done


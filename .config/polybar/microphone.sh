#!/bin/bash
#pacmd list-sources | grep "\* index:" -A 7 | grep front | cut -d '/' -f 2 | xargs
#pacmd list-sources | grep "\* index:" -A 11 | grep muted | xargs | cut -d " " -f 2

vol=$(pacmd list-sources | grep "\* index:" -A 7 | grep front | cut -d '/' -f 2 | xargs)
muted=$(pacmd list-sources | grep "\* index:" -A 11 | grep muted | xargs | cut -d " " -f 2)
if [[ $muted == "yes" ]]; then
    echo "%{F$1}%{F-}"
else
    echo "" $vol
fi


LANG=en_US.UTF-8 pactl subscribe | while read -r event; do
    if [[ "$event" == *"source"* ]]; then
        vol=$(pacmd list-sources | grep "\* index:" -A 7 | grep front | cut -d '/' -f 2 | xargs)
        muted=$(pacmd list-sources | grep "\* index:" -A 11 | grep muted | xargs | cut -d " " -f 2)
        if [[ $muted == "yes" ]]; then
            echo "%{F$1}%{F-}"
        else
            echo " $vol"
        fi
    fi
done
#!/bin/bash
. $(dirname $0)/color.conf
. $(dirname $0)/path.conf
. $(dirname $0)/style.conf

[ -e "${memory}" ] && rm -rf "${memory}"
mkdir $memory
cp $(dirname $0)/memory_preset/* $memory


monitor=eDP-1

geometry=$(xrandr | grep $monitor | cut -d' ' -f 4 | sed  's/x[^+-]*+/x'"$geo_height"'+/g'  )

output(){
echo %{B#$color_tray_bg}123
#echo %{B#ff4444}123
}
output | lemonbar -p -g $geometry -B#ff0000 -n panel_$monitor





#ps -au | grep panel_eDP-1 | grep -v grep | cut -d' ' -f2- | sed 's/^[ \t]*//' | cut -d' ' -f1

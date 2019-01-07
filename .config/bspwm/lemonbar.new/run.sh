#!/bin/bash
. $(dirname $0)/color.conf
. $(dirname $0)/path.conf
. $(dirname $0)/style.conf

[ -e "${memory}" ] && rm -rf "${memory}"
mkdir $memory
cp $(dirname $0)/memory_preset/* $memory

#fonts=""
#while read line
#do
#	fonts="$fonts$(echo $line | sed "s/\ /\ /g")"	
#done < $(dirname $0)/font.conf
#echo $fonts



monitor=eDP-1

geometry=$(xrandr | grep $monitor | cut -d' ' -f 4 | sed  's/x[^+-]*+/x'"$geo_height"'+/g'  )

output(){
echo %{B#$color_tray_bg}123 
#echo %{B#ff4444}123
}
output | lemonbar -p -g $geometry -B#000000 -n panel_$monitor -f lucidasans-italic-10 -f "-misc-font awesome 5 free-medium-r-normal--0-100-90-90-p-0-iso10646-1"





#ps -au | grep panel_eDP-1 | grep -v grep | cut -d' ' -f2- | sed 's/^[ \t]*//' | cut -d' ' -f1
#echo 123  | lemonbar -p -f -g 1920x16 -B #000000 -f lucidasans-italic-10 -f "-misc-font awesome 5 free-medium-r-normal--0-100-90-90-p-0-iso10646-1"



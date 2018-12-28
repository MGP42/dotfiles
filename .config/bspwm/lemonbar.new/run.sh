#!/bin/bash
. $(dirname $0)/color.conf
. $(dirname $0)/path.conf
. $(dirname $0)/style.conf


output(){
echo %{B#$color_tray_bg}123
#echo %{B#ff4444}123
}
output
output | lemonbar -p -g $geo_heightx$geo_width -B#ff0000

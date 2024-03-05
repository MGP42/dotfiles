#!/bin/bash

# List all active monitors
active_monitors=$(xrandr | grep " connected " | grep -v "connected (" | cut -d' ' -f1)

# Find the rightmost monitor among the active ones
x_max=0
most_right_monitor=""
for monitor in $active_monitors; do
	specs=$(xrandr | grep $monitor | grep -o "[0-9]*x[0-9]*+[0-9]*+[0-9]*")
	x=$(echo $specs | cut -d'x' -f1)
	w=$(echo $specs | cut -d'+' -f2)
	x=$((x+w))
	if (( x> x_max ));then
		x_max=$x
		most_right_monitor=$monitor
	fi
done

# Find all monitors that are connected but not active
connected_monitors=$(xrandr | grep " connected (" | cut -d' ' -f1)

# Add new monitors to the right
for monitor in $connected_monitors; do
	xrandr --output $monitor --right-of $most_right_monitor --auto
	most_right_monitor=$monitor
done

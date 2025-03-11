#!/bin/bash
bash ~/.config/bspwm/bspwm-colors.sh
if [ ! -d ~/.local/share/SpeedCrunch/color-schemes ]; then
	mkdir -p ~/.local/share/SpeedCrunch/color-schemes
fi
cp ~/.cache/wal/colors-speedcrunch.json ~/.local/share/SpeedCrunch/color-schemes/
pywalfox update

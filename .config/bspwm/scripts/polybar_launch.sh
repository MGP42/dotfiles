killall polybar

### start a ar for each monitor
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done

### Set Wallpaper
bash ~/.fehbg

notify-send Polybar "Polybar reloaded" &

killall polybar

### start a ar for each monitor
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main &
done

### Set Wallpaper
feh --bg-fill ~/Bilder/.tmp/desktop_bg.png

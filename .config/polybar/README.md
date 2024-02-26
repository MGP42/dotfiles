# Polybar

## Dependencies
- Font Awesome
- redshift
- brightnessctl
- pulseaudio
- alacritty
- playerctl


## Main
![](../../.git-md-img/polybar.jpg)

### audio (speaker/microphone)
leftclick to toogle<br>
scrolling to increase/decrease volume

### audioplayer
the audioplayer module is only active when there is an active audio player<br>
the audioplayer uses playerctl to detect and interact with audios<br>
the buttons act according to their appreance<br>
left click on the text pauses<br>
right click skips to the next track<br>
middle click goes to the previous track

*playerctl isn't exactly precice when picking the correct audio player so having more than one might lead to issues<br>
yes this includes browser*

### battery 
left click on module to open tinybar in battery mode

### brightness
left click to redshift<br>
middle click to blue shift<br>
right click to normalize<br>
scrolling to increase/decrease brightness

### cpu
left click on module to open tinybar in cpu mode<br>
right click on module to open tinybar in top mode<br>
middle click to open htop sorted by cpu

### network
left click on module to open tinybar in the according network mode

### ram
left click on module to open tinybar in ram mode<br>
right click on module to open tinybar in top mode<br> 
middle click to open htop sorted by ram<br>

### worskapces
left click on Monitor to trigger the monitor setup script from bspwm (useful when connecting to another monitor)<br>
right click on Monitor to kill polybar and run the start script again (useful when connecting to another monitor)<br>
left click on desktop to switch to desktop

## Tinybar
Tinybar is a helper bar to act as a temporary bar below the main bar providing data that wouldn't fit otherwise

right click will always close the bar
trying to open the already open bar will close it as well

### battery
![](../../.git-md-img/tinybar_battery.jpg)

### cpu
![](../../.git-md-img/tinybar_cpu.jpg)

### network
![](../../.git-md-img/tinybar_wifi.jpg)
left click on any iformation copies the information to the clipoard

### ram
![](../../.git-md-img/tinybar_ram.jpg)

### top
![](../../.git-md-img/tinybar_top.jpg)
middle click on a directory to open it in flielight


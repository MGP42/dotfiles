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
### worskapces
left click on desktop to switch to desktop

### network
left click on module to open tinybar in the according network mode

### ram
left click on module to open tinybar in ram mode<br>
right click on module to open tinybar in top mode<br> 
middle click to open htop sorted by ram<br>

### cpu
left click on module to open tinybar in cpu mode<br>
right click on module to open tinybar in top mode<br>
middle click to open htop sorted by cpu

### battery 
left click on module to open tinybar in battery mode

### audioplayer
the audioplayer uses playerctl to detect and interact with audios<br>
the buttons act according to their appreance<br>
left click on the text pauses<br>
right click skips to the next track<br>
middle click goes to the previous track

*playerctl isn't exactly precice when picking the correct audio player so having more than one might lead to issues<br>
yes this includes browser*

## Tinybar
Tinybar is a helper bar to act as a temporary bar below the main bar providing data that wouldn't fit otherwise

right click will always close the bar
### top
![](../../.git-md-img/tinybar_top.jpg)
middle click on a directory to open it in flielight

### cpu
![](../../.git-md-img/tinybar_cpu.jpg)

### ram
![](../../.git-md-img/tinybar_ram.jpg)

### network
![](../../.git-md-img/tinybar_wifi.jpg)
left click on any iformation copies the information to the clipoard

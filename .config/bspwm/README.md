# BSPWM-Config

DISCLAIMER: the Readme is incomplete and so are the Scripts. Even tho it runs smooth for me expect Bugs
or missing Programms i forgot to mention.

## Structure
	Programs
	Dropdown
	Changes
	To Do

## Necessary Programs
	Conky
	Lemonbar
	BSPWM
	alsa-utils
	stalonetray
	sxhkdrc
	compton
	termite
	compton

## Changes
### Terminal
	Terminal is set to Termite if you wish to change it you have to replace
	Termite in the sxhkdrc with the Terminal you want to use.

### Info Bar
	The Core of the Info Bar is the Lemonbar.
	For the Tray im using stalonetray.
	To change the Tray, you have to replace it in ./panel/lemonbar.sh
	should be somewhere at the Bottom.
	To replace the entire Bar clear the panel folder and replace the lemonbar.sh function call
	in the bspwmrc

### Alsa Utils
	to replace Alsa Utils you have to replace the volume lines in sxhkdrc and the
	Volume dropdown in the panel.
	I don't recomend doing that unless you know what you're doing.

## To Do
	Autostart still in bspwmrc should be seperated
	Alternative for the Conky Dropdown or update performace of it
	Battery Symbol / Warning / Color changen when low
	Multi-Monitor

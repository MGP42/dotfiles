
#!/usr/bin/bash

. $(dirname $0)/lemonbar_style
echo "none" > $(dirname $0)/dropdown/active &

panel_fifo=$(dirname $0)/$panel_fifo


tmp=0
dropdown="none"

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"


##################################################################################################
# Modules ########################################################################################
##################################################################################################


Dropdown(){
        if [ $dropdown != none ]; then
                killall conky-dropdown
        fi
        if [ $dropdown != $1 ]; then
                $(dirname $0)/dropdown/conky-dropdown -qc $1
                dropdown = "$1"
        else
                dropdown = "none"
        fi
}

Clock(){
        while true; do
        echo "clock\ $(date +%H:%M) " >> ${panel_fifo}
        sleep 10
        done
}

Date(){
        while true;do
        echo "date\ $icon_clock $(date "+%a %d %b")" >> ${panel_fifo}
        sleep 10
        done

}

Battery(){
        while true; do
	tmp=$(acpi --battery | cut -d, -f2)
        echo "battery\ %{A:bash $(dirname $0)/dropdown/dropdown.sh battery:} $tmp %{A}" >> ${panel_fifo}
        sleep 10
        done
}

Conky(){
	conky -c $(dirname $0)/lemonbar_conky | while read -r line; do
		echo $line >> ${panel_fifo}
	done
		
}

Window(){
	while true;do
		Fast_Window &
		sleep 1
	done
}

##################################################################################################
# One Time Execute with extern update ############################################################
#################################################################################################
# You could implement this as an time based update (like above)
# Problem is you usualy want to set the time for them as close to zero as possible
# Don't do it, it's unperformant as hell (trust me i tried it)
# Actually some of the above also shouldn't be time based
#
# Do not care Won't Fix (atleast for now)


Volume(){
	echo  "volume\ $(amixer get Master |tail -1| awk -F'[][]' '/%/ {if ($4 == "off") {print "×"} else {printf "%s", $2}}')" >> ${panel_fifo}
}

Desktop(){
	color_old=$color_tray_bg													# Background Color before the Desktop Module starts
	atm=null															# Marker if the active Desktop is beeing processed (boolean, more or less)
	tmp=$(echo "$(Spacer_right $color_main2_bg $color_main2_fg $color_old) ")							# Default Spacer (Current Desktop not first)

	for i in $(bspc query -D); do
		if [ "$(bspc query -d -D)" == "$i" ]											# If Desktop is Active
                then
			if [ $atm == "0" ]
			then
				tmp=$(echo "${tmp::-1} $(Spacer_right $color_main1_bg $color_main1_fg $color_main2_bg)")		# Add Active Desktop Spacer to Output with main 1 Color and remove inactive Spacer
			else
				tmp=$(echo "$(Spacer_right $color_main1_bg $color_main1_fg $color_old) ")				# Active Desktop is the first Desktop, throw Default Spacer in the Garbage and use it's own
			fi
				tmp=$(echo "$tmp $(bspc query -T -d $i | cut -d'"' -f4) ")						# Actual Desktop Name
			atm=1														# set processed Desktop to active
		else
			if [ "$(bspc query -N -n .window -d $i)" != "" ]								# If inactive Desktop has no Windows do no output
			then
				if [ $atm == "1" ]											# If last Desktop was the active one set special Spacer
				then
					tmp=$(echo "$tmp $(Spacer_right $color_main2_bg $color_main2_fg $color_main1_bg)")
				fi
				tmp=$(echo " $tmp $(bspc query -T -d $i | cut -d'"' -f4) $sep_l_right")					# Desktop Name + Spacer for next Desktop (inactive)
				atm=0													# set processed Desktop to inactive
			fi
		fi
	done
	
	if [ $atm == "1" ]														# Set final Spacer dependent on: was last Desktop active?
	then
		tmp=$(echo "$tmp $(Spacer_right $color_wn_bg $color_wn_fg $color_main1_bg)")
	else
		tmp=$(echo "${tmp::-1} $(Spacer_right $color_wn_bg $color_wn_fg $color_main2_bg)")
	fi
	Fast_Window &															# reload Windowname
	echo "desktop\ $tmp" >> ${panel_fifo}												# send it to parer
}

Fast_Window(){																# Windowname extern updater
	echo  "windowname\ $(xdotool getwindowfocus getwindowname)" >> ${panel_fifo}
}

##################################################################################################
# Parser #########################################################################################
##################################################################################################

lemonbar_parser(){				#Parses FiFo to Variables
        while IFS= read -r line; do
                index=$(echo $line | cut -d\\ -f1)
                value=$(echo $line | cut -d\\ -f2)
                case $index in
                        (clock) clock=$value;;
			(memory)
				memory="%{A:bash $(dirname $0)/dropdown/dropdown.sh memory:}"
				memory+="$icon_memory$value"
				memory+=" %{A}"
				;;
			(network) 
				network="%{A:bash $(dirname $0)/dropdown/dropdown.sh network:}"
				network+="$icon_up $(echo $value | cut -d+ -f1)"
                                network+=" $sep_l_left "
                                network+="$icon_down $(echo $value | cut -d+ -f2)"
				network+=" %{A}"
				;;
			(cpu) 
				cpu="%{A:bash $(dirname $0)/dropdown/dropdown.sh cpu:}"
				cpu+="$icon_cpu $value%"
				cpu+=" %{A}"
				;;
                        (date) date=$value;;
                        (battery) battery=$value;;
                        (desktop) desktop=$value;;
                        (volume) 
				volume="%{A:bash $(dirname $0)/dropdown/bash termite_alsamixer:}"
				volume+=$icon_volume$value
				volume+=" %{A}"
				;;
                        (conky) conky=$value;;
                        (windowname) windowname=$value;;
			(extern) $($value);;
                esac
        done < ${panel_fifo}

}

##################################################################################################
# Formater #######################################################################################
##################################################################################################

Spacer_left(){					#Spacer to the left <bgcolor|fgcolor>
        #color_old=$color_bg
        color_bg=$1
        color_fg=$2
        echo -n "%{F#$color_bg}$sep_left%{B#$color_bg}%{F#$color_fg}"
}

Spacer_right(){					#Spacer to the right <bgcolor|fgcolor|old bgcolor>
        color_old=$3				#$color_bg	#Bug c_old
        color_bg=$1
        color_fg=$2
        echo "%{F#$color_old}%{B#$color_bg}$sep_right%{F#$color_fg}"
}



##################################################################################################
# Output #########################################################################################
##################################################################################################
# start tools
Clock &
Date &
Battery &
Conky &
Volume &
Window &
Desktop &

lemonbar_output(){
	while true; do
		echo "%{F#$color_wn_fg}%{B#$color_wn_bg}"                       #Anti fuck up / do not touch    # Srsly it does exactly what it's suposed to do, do not change it,
                echo -n "%{F#$color_tray_fg}%{B#$color_tray_bg}"                #Anti fuck up / do not touch    # or live with the consequences (weird first color Bullshit Bingo)

		lemonbar_parser

		# left
		echo -n  "       "									#Space for Tray
		echo -n "$desktop"									#Desktop (has all the Spacers itsleft)
		echo -n "$windowname"									#windowname
		# right
		echo -n %{r}
		echo -n "$(Spacer_left $color_info1_bg $color_info1_fg) $network"			#Network	+Spacer
		echo -n "$(Spacer_left $color_info2_bg $color_info2_fg) $cpu$sep_l_left $memory"	#CPU		+Spacer
		echo -n "$(Spacer_left $color_info1_bg $color_info1_fg)$battery"			#Batetry	+Spacer
		echo -n "$(Spacer_left $color_info2_bg $color_info2_fg) $volume"			#Volume 	+Spacer
		echo -n "$(Spacer_left $color_info1_bg $color_info1_fg)$date"				#Date		+Spacer
		echo -n " $(Spacer_left $color_main1_bg $color_main1_fg)$clock"				#Clock		+Spacer
	done	
}

sleep 0.2 && stalonetray -i 16 --max-geometry 4x1 --scrollbars horizontal  -d "all" -t "true"  --scrollbars-step "16" &			# Lemonbar with delay to set it infront of the lemonbar
lemonbar_output | lemonbar -p -g $geometry  -B "#$color_wn_bg" -F "#$color_wn_fg"    -f $font_symbol  -f $font_basic | /bin/bash	# The Actual Bar







##################################################################################################
# BUGS ###########################################################################################
##################################################################################################
#
#	c_old
#		color_old not global defined
#		if global defined then Spacer_right has no need for color_old in the
#		Constructor
#			-Fix delayed
#

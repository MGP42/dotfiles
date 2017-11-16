
#!/usr/bin/bash

. $(dirname $0)/lemonbar_style
echo "none" > $(dirname $0)/dropdown/active &

panel_fifo=$(dirname $0)/$panel_fifo


tmp=0
dropdown="none"

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"


##################################################################################################
# Tools ##########################################################################################
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
        echo "battery\ %{A:bash $(dirname $0)/dropdown/dropdown.sh battery:} $(acpi --battery | cut -d, -f2) %{A}" >> ${panel_fifo}
        sleep 1
        done
}

Conky(){
	conky -c $(dirname $0)/lemonbar_conky | while read -r line; do
		echo $line >> ${panel_fifo}
	done
		
}

Window(){
	while true;do
		echo  "windowname\ %{A4:i3lock:}$(xdotool getwindowfocus getwindowname)%{A4}" >> ${panel_fifo}
		sleep 1
	done
}

##################################################################################################
# One Time Execute with extern update ############################################################
#################################################################################################

Volume(){
	echo  "volume\ $(amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "×"} else {printf "%d%", $2}}')">> ${panel_fifo}
}

Desktop(){
	color_old=$color_tray_bg
	first=1
	atm=null
	tmp=$(echo "$(Spacer_right $color_main2_bg $color_main2_fg $color_old) ")

	for i in $(bspc query -D); do
		if [ "$(bspc query -d -D)" == "$i" ]
                then
			if [ $atm == "0" ]
			then
				tmp=$(echo "${tmp::-1} $(Spacer_right $color_main1_bg $color_main1_fg $color_main2_bg)")	
			else
				tmp=$(echo "$(Spacer_right $color_main1_bg $color_main1_fg $color_old) ")
			fi
				tmp=$(echo "$tmp $(bspc query -T -d $i | cut -d'"' -f4) ")
			atm=1
		else
			if [ "$(bspc query -N -n .window -d $i)" != "" ]
			then
				if [ $atm == "1" ]
				then
					tmp=$(echo "$tmp $(Spacer_right $color_main2_bg $color_main2_fg $color_main1_bg)")
				fi
				tmp=$(echo " $tmp $(bspc query -T -d $i | cut -d'"' -f4) $sep_l_right")
				atm=0
			fi
		fi
	done
	
	if [ $atm == "1" ]
	then
		tmp=$(echo "$tmp $(Spacer_right $color_tray_bg $color_tray_fg $color_main1_bg)")
	else
		tmp=$(echo "${tmp::-1} $(Spacer_right $color_tray_bg $color_tray_fg $color_main2_bg)")
	fi
	Fast_Window &
	echo "desktop\ $tmp" >> ${panel_fifo}
}

Fast_Window(){
	echo  "windowname\ %{A4:i3lock:}$(xdotool getwindowfocus getwindowname)%{A4}" >> ${panel_fifo}
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
			(memory) memory="$icon_memory$value";;
			(network) 
				network="$icon_up $(echo $value | cut -d+ -f1)"
                                network+=" $sep_l_left "
                                network+="$icon_down $(echo $value | cut -d+ -f2)"
				;;
			(cpu) cpu="$icon_cpu $((value/4))%";;
                        (date) date=$value;;
                        (battery) battery=$value;;
                        (desktop) desktop=$value;;
                        (volume) volume=$icon_volume$value;;
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
        color_old=$3	#$color_bg	#Bug c_old
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
		lemonbar_parser
		# left
		echo -n "       "
		echo -n "$desktop"
		echo -n "$windowname"
		#echo -n " $(Spacer_right $color_main1_bg $color_main1_fg $color_tray_bg) "
		#echo -n " $(Spacer_right $color_tray_bg $color_tray_fg $color_main1_bg) $windowname "
		# right
		echo -n %{r}

		echo -n " $(Spacer_left $color_info1_bg $color_info1_fg) $network"
		echo -n " $(Spacer_left $color_info2_bg $color_info2_fg) $cpu $sep_l_left $memory"
		echo -n " $(Spacer_left $color_info1_bg $color_info1_fg)$battery"	#Batetry+Spacer
		echo -n "$(Spacer_left $color_info2_bg $color_info2_fg) $volume"	#Volume +Spacer
		echo -n " $(Spacer_left $color_info1_bg $color_info1_fg)$date"		#Date	+Spacer
		echo -n " $(Spacer_left $color_main1_bg $color_main1_fg)$clock"		#Clock	+Spacer

		echo %{F#$color_tray_fg}%{B#$color_tray_bg}		#Anti fuck up / do not touch
	done	
}


lemonbar_output | lemonbar -p -g $geometry  -B "#000000" -F "#ffffff"    -f $font_symbol  -f $font_basic | /bin/bash







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

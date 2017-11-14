#!/usr/bin/bash

. $(dirname $0)/lemonbar_style
echo "none" > $(dirname $0)/dropdown/active &

color_old=""
color_bg=$c_home_bg
color_fg=$c_home_fg


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
        echo "clock\ $(date +%H:%M) " >> lb_fifo.tmp
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


Spacer_right(){
	color_old=$color_bg
	color_bg=$1
	color_fg=$2
	echo "%{F#$color_old}%{B#$color_bg}$sep_right%{F#$color_fg}"
}

Spacer_left(){
        #color_old=$color_bg
        color_bg=$1
        color_fg=$2
        echo "%{F#$color_bg} $sep_left%{B#$color_bg} %{F#$color_fg}"
}

sys_info_conky(){
	tmp=0
 	conky -c $(dirname $0)/lemonbar_conky | while read -r  line; do
		index=$(echo $line | cut -d\\ -f1)
		value=$(echo $line | cut -d\\ -f2)
		if [ "$index" = 'start' ]; then
			tmp=1
		fi
		if [ $tmp = '1' ]; then
		case $index in
			cpu)
					echo -n "%{A:bash $(dirname $0)/dropdown/dropdown.sh cpu:}"
				echo -n $(Spacer_left $c_cpu_bg $c_cpu_fg)
				echo -n $icon_cpu $((value/4))%
					echo -n " %{A}"
				;;
			memory)
					echo -n "%{A:bash $(dirname $0)/dropdown/dropdown.sh memory:}"
				echo -n "$sep_l_left " #$(Spacer_left $c_memory_bg $c_memory_fg)
				echo -n $icon_memory $value
					echo -n "%{A}"
				;;
			network)
					echo -n "%{A:bash $(dirname $0)/dropdown/dropdown.sh network:}"
                		echo -n $(Spacer_left $c_network_bg $c_network_fg)
				echo -n $icon_up $(echo $value | cut -d+ -f1)
                		echo -n " $sep_l_left "
				echo -n $icon_down $(echo $value | cut -d+ -f2)
					echo -n "%{A}"
				;;
		esac
    fi
	done
}

sys_desktop(){
	while true;do
	export color_bg=$c_home_bg
	tmp=$(echo "$(Spacer_right $c_desktop_bg $c_desktop_fg) ")
	check=0
	for i in $(bspc query -D); do

        	if [ "$(bspc query -d -D)" == "$i" ]
        	then
			check=1
			if [ "$tmp" == "$(echo "$(Spacer_right $c_desktop_bg $c_desktop_fg) ")" ]
			then
				tmp=" "
			else
				export color_bg=$c_desktop_bg
			fi
                	tmp=$(echo "${tmp::-1}$( Spacer_right $c_desktop2_bg $c_desktop2_fg) $(bspc query -T -d $1 | cut -d'"' -f4) ")
			export color_bg=$c_desktop2_bg
			tmp=$(echo "$tmp$( Spacer_right $c_desktop_bg $c_desktop_fg) ")
        	else
                	if [ "$(bspc query -N -n .window -d $i)" != "" ]
                	then
				check=0
                	        tmp=$(echo "$tmp $(bspc query -T -d $i | cut -d'"' -f4) $sep_l_right")
                	fi
        	fi
	done
	export color_bg=$c_desktop_bg
	if [ "$(bspc query -d -D)" == "$i" ]
	then
		export color_bg=$c_desktop2_bg
		tmp=${tmp::-34}
	fi
	echo  "desktop\ ${tmp::-1} $(Spacer_right 000000 ffffff) " >> ${panel_fifo}
	echo  "windowname\ %{A4:i3lock:}$(xdotool getwindowfocus getwindowname)%{A4}" >> ${panel_fifo}
	sleep 0.1
	done
}

oneline(){
	while true;do
	echo  "volume\ $icon_volume $(amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "×"} else {printf "%d%", $2}}')">> ${panel_fifo}
	sleep 1
	done
}

sys_conky(){
	while true; do
		echo  "conky\ $(sys_info_conky)" >> ${panel_fifo}
		sleep 1
	done
}


########################
########################
########################

Clock &
Date &
Battery &
sys_desktop &
oneline &
sys_conky &

lemonbar_parser(){
	while IFS= read -r line; do
                index=$(echo $line | cut -d\\ -f1)
                value=$(echo $line | cut -d\\ -f2)
		case $index in
			(clock)	clock=$value;;
			(date) date=$value;;
			(battery) battery=$value;;
			(desktop) desktop=$value;;
			(volume) volume=$value;;
			(conky) conky=$value;;
			(windowname) windowname=$value;;
		esac
	done < ${panel_fifo}

}


lemonbar_output(){
	test=0
	while true; do
		lemonbar_parser
		
		echo -n "%{F#000000}%{B#000000}"                        # initialize colors
#                echo -n "$icon_home "                                     	# HOME Button
		
		echo -n "        "		

                # echo -n "$(Spacer_right c_task_fg c_task_bg)"
		echo -n $desktop
		echo -n "$windowname"						#windowname

		echo -n %{r}							#RIGHT
		echo -n "%{F#$c_task_fg}%{B#$c_task_bg}"
		
		echo -n "$conky"						#System
		
		echo -n $(Spacer_left $c_battery_bg $c_battery_fg)
		echo -n $battery
		
		echo -n $(Spacer_left $c_volume_bg $c_volume_fg)
		echo -n "$volume "
		
		echo -n $(Spacer_left $c_date_bg $c_date_fg)
		echo -n $date
		
		echo -n $(Spacer_left $c_clock_bg $c_clock_fg)
		echo -n $clock

		echo  "%{F#$c_task_fg}%{B#$c_task_bg}"                          # anti fuck up / do not touch
	done
}

# sys_info_conky 
lemonbar_output | lemonbar -p -g $geometry  -B "#000000" -F "#ffffff"    -f $font_symbol  -f $font_basic | /bin/bash 

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

##################################################################################################
# One Time Execute with extern update ############################################################
#################################################################################################

Volume(){
	bash $(dirname $0)/extern_update/Volume
}

Desktop(){
	echo 123
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
			(memory) memory="$icon_memory $value";;
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



##################################################################################################
# Output #########################################################################################
##################################################################################################
# start tools
Clock &
Date &
Battery &
Conky &
Volume &

lemonbar_output(){
	while true; do
		lemonbar_parser
		echo -n %{F#$color_tray_fg}%{B#$color_tray_bg}

		# left
		echo -n $cpu
		echo -n $network
		echo -n $memory

		# right
		echo -n %{r}
		
		echo -n " $(Spacer_left $color_info1_bg $color_info1_fg)$battery"	#Batetry+Spacer
		echo -n "$(Spacer_left $color_info2_bg $color_info2_fg) $volume"	#Volume +Spacer
		echo -n " $(Spacer_left $color_info1_bg $color_info1_fg)$date"		#Date	+Spacer
		echo " $(Spacer_left $color_main1_bg $color_main1_fg)$clock"		#Clock	+Spacer
	done	
}


lemonbar_output | lemonbar -p -g $geometry  -B "#000000" -F "#ffffff"    -f $font_symbol  -f $font_basic | /bin/bash


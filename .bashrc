
case "$TERM" in
	xterm*)

		constps1=""
		userps1="\u"
		coloruser="\[\e[44;37m\]"
		colorpath="\[\e[46;34m\]\[\e[46;34m\]"
		colordefault="\[\e[0m\]"
		colorend="\[\e[0;36m\]"



		colorsshuser="\[\e[0;34m\]"


		if [ $(id -u) -eq 0 ]; then
		        coloruser="\[\e[41;37m\]"
		        colorpath="\[\e[46;31m\]\[\e[46;34m\]"
			colorsshuser="\[\e[0;31m\]"
		fi




		if [ -n "$SSH_CLIENT" ]; then
			colorpath="\[\e[46;33m\]\[\e[46;34m\]"
			userps1=$userps1$colorsshuser" @ \[\e[0;33m\]\[\e[43;30m\]\h"
		fi
		#colorprompt1=$coloruser



		PS1=$coloruser$userps1$colorpath" \W"$colorend""$colordefault" "
	;;
	*)
		constps1=""
		userps1="\u"
		colorroot="\[\e[31m\]"
		colorssh="\[\e[93m\]"
		coloruser="\[\e[36m\]"
		colordefault="\[\e[0m\]"



		if [ -n "$SSH_CLIENT" ]; then
			coloruser=$colorssh
			userps1=$userps1$colorssh" @ \h"
		fi
		colorprompt1=$coloruser
	

		if [ $(id -u) -eq 0 ]; then
			coloruser=$colorroot
		fi


		PS1=$coloruser"["$userps1$coloruser"]"$colordefault" \W"$coloruser"\$ "$colordefault		
	;;
esac















########################################################################
############################ alias #####################################
########################################################################
alias "cd.."="cd .."
alias "pacman"="sudo pacman"
alias "ls-la"="ls -la"
alias "ls"="ls --color=auto"
alias "dolphin"="DESKTOP_SESSION=kde dolphin"
alias "unilpq"='ssh uni "lpq; echo ; lpq -P zarquon"'

########################################################################
############################## export ##################################
########################################################################
export EDITOR=nano

export PATH=~/.local/bin:$PATH
export TERM=termite

##### bspwm
#export PANEL_FIFO="/tmp/panel-fifo"
#export PATH=$PATH:/home/dki/.config/bspwm/panel/
#then: source ~/.bashrc
# setxkbmap -option grp:alt_shift_toggle -layout de -variant ,phonetic &

export TERM=xterm

clear

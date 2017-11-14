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


########################################################################
############################ alias #####################################
########################################################################
alias "cd.."="cd .."
alias "pacman"="sudo pacman"
alias "ls-la"="ls -la"
alias "ls"="ls --color=auto"
alias "dolphin"="DESKTOP_SESSION=kde dolphin"

########################################################################
############################## export ##################################
########################################################################
export EDITOR=nano

export PATH=~/.local/bin:$PATH


##### bspwm
#export PANEL_FIFO="/tmp/panel-fifo"
#export PATH=$PATH:/home/dki/.config/bspwm/panel/
#then: source ~/.bashrc
# setxkbmap -option grp:alt_shift_toggle -layout de -variant ,phonetic &

export TERM=xterm

clear

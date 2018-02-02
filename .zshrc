#test

# Lines configured by zsh-newuser-install
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dki/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

###########################################################
export HISTSIZE=2000
export SAVEHIST=2000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY

###########################################################


bindkey    "^[[H"    beginning-of-line
bindkey    "^[[F"    end-of-line
bindkey    "^[[3~"    delete-char


###########################################################

lnext(){
	spacer=" %F"$2""%F$1%K$2
	oldfg=$1
	oldbg=$2
}

rnext(){
	spacer=" %F"$oldbg"%K"$2"%F"$1
	oldfg=$1
	oldbg=$2
}

###########################################################
local spacer=''
local abc=''

#user path jobs git gitsynced

zsh_color=(
    '{white}'           #user foreground
    '{blue}'            #user background
    '{black}'           #path foreground
    '{cyan}'            #path background
    '{black}'           #running jobs foreground
    '{white}'           #running jobs background
    '{white}'           #git HEAD not synced foreground
    '{red}'             #git HEAD not synced background
    '{black}'           #git HEAD synced foreground
    '{green}'           #git HEAD synced background
)
local colorsshfg='{black}'
local colorsshbg='{yellow}'

local colorrootfg='{white}'
local colorrootbg='{red}'

local oldfg=${zsh_color[1]}
local oldbg=${zsh_color[2]}


local zshuser=" %n"
###########################################################
if [ $(id -u) -eq 0 ]; then             #if user is ROOT change usercolor
    zsh_color[2]=$colorrootbg
	zsh_color[1]=$colorrootfg
	oldbg=${zsh_color[2]}
fi

if [ -n "$SSH_CLIENT" ]; then           #if connected via SSH add Hostnamej
	rnext %f %k
	zshuser=$zshuser$spacer""
	lnext $colorsshfg $colorsshbg
	zshuser=$zshuser$spacer" %m"
fi
	

###########################################################
function jobsrunning(){                     #get number of background jons running
	#echo $(jobs -rp | wc -l)
	if [ $(jobs -rp | wc -l) -ne 0 ];          #if 0 do not print
	then
		lnext ${zsh_color[5]} ${zsh_color[6]}
		echo $spacer $(jobs -rp | wc -l)
	fi
}

function gitinfo(){                         #get git info
	tmp=$(git symbolic-ref HEAD 2> /dev/null) 
  	if [[ -n $(git status --porcelain 2> /dev/null) ]]; then     #is git synced?
		lnext ${zsh_color[7]} ${zsh_color[8]}
	else
		lnext ${zsh_color[9]} ${zsh_color[10]}
	fi	
	if [[ $tmp != '' ]];
	then
		echo $spacer ${tmp#refs/heads/}
	fi
}



##########################################################




case "$TERM" in
	xterm*)
		PROMPT="%{%f%k%}%F"${zsh_color[1]}"%K"${zsh_color[2]}$zshuser 
		rnext ${zsh_color[3]} ${zsh_color[4]}
		PROMPT+=$spacer" %1~"
		rnext '' %k
		PROMPT+=$spacer"%f%k "
		

		oldfg=''
		oldbg=''

        #RIGHT SIDE

		setopt PROMPT_SUBST           #function calls active
		RPROMP="%f%k"
		RPROMPT+='$(gitinfo)'
		RPROMPT+='$(jobsrunning)'

		RPROMPT+=" %f%k"
	;;
	*)
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


##### bspwm
#export PANEL_FIFO="/tmp/panel-fifo"
#export PATH=$PATH:/home/dki/.config/bspwm/panel/
#then: source ~/.bashrc
# setxkbmap -option grp:alt_shift_toggle -layout de -variant ,phonetic &

export TERM=xterm

clear

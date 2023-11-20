unsetopt beep                               #disable beeping

zstyle :compinstall filename '/home/dki/.zshrc'
autoload -Uz compinit
compinit

# HISTORY ##############################################################
########################################################################

export HISTSIZE=2000                        #History Size
export SAVEHIST=2000
export HISTFILE=~/.zsh_history              #History File
setopt INC_APPEND_HISTORY

# BINDKEY ##############################################################
########################################################################

bindkey    "^[[H"    beginning-of-line
bindkey    "^[[F"    end-of-line
bindkey    "^[[3~"    delete-char

# SPACER ###############################################################
########################################################################

lnext(){                            #left Arrow spacer
	zsh_spacer=" %F"$2""%F$1%K$2
	zsh_color[15]=$1
	zsh_color[16]=$2
}
rnext(){                            #right Arrow spacer
	zsh_spacer=" %F"${zsh_color[16]}"%K"$2"%F"$1
	zsh_color[15]=$1
	zsh_color[16]=$2
}

# GLOBAL VARIABLES #####################################################
########################################################################

local -a zsh_color	#define before initialize BS
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
    '{black}'           #ssh foreground
    '{yellow}'          #ssh background
    '{white}'           #root foreground
    '{red}'             #root background
    '{white}'               #old color foreground tmp savestate
    '{blue}'                #old color background tmp savestate
)

local zsh_spacer=''     #tmp spacer save state | cause subroutine global variable change does not work
local zsh_user=" %n"    #user design | contains HOST if on SSH

# DEFINE USER ##########################################################
########################################################################

if [ $(id -u) -eq 0 ]; then             #if user is ROOT change usercolor
    zsh_color[2]=${zsh_color[14]}
	zsh_color[1]=${zsh_color[13]}
	zsh_color[16]=${zsh_color[2]}
fi

if [ -n "$SSH_CLIENT" ]; then           #if connected via SSH add Hostnamej
	rnext %f %k
	zsh_user=$zsh_user$zsh_spacer""
	lnext ${zsh_color[11]} ${zsh_color[12]}
	zsh_user=$zsh_user$zsh_spacer" %m"
fi
	
# INFO COLLECTOR #######################################################
########################################################################

function jobsrunning(){                     #get number of background jons running
	#echo $(jobs -rp | wc -l)
	if [ $(jobs -rp | wc -l) -ne 0 ];          #if 0 do not print
	then
		lnext ${zsh_color[5]} ${zsh_color[6]}
		echo $zsh_spacer $(jobs -rp | wc -l)
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
		echo $zsh_spacer ${tmp#refs/heads/}
	fi
}

# PROMPT ###############################################################
########################################################################

case "$TERM" in
	xterm*)
		PROMPT="%{%f%k%}%F"${zsh_color[1]}"%K"${zsh_color[2]}$zsh_user 
		rnext ${zsh_color[3]} ${zsh_color[4]}     #spacer to path
		PROMPT+=$zsh_spacer" %1~"
		rnext '' %k                               #spacer to input
		PROMPT+=$zsh_spacer"%f%k "
		
        
        #RIGHT SIDE
		
		zsh_color[15]=''                          #reset tmp old color for reuse on right side
		zsh_color[16]=''                          #reset tmp old color for reuse on right side

		setopt PROMPT_SUBST           #function calls active
		RPROMPT+='$(gitinfo)'
		RPROMPT+='$(jobsrunning)'

		RPROMPT+=" %f%k"
	;;
	*)
	;;
esac

# ALIAS ################################################################
########################################################################

alias "cd.."="cd .."
alias "pacman"="sudo pacman"
alias "ls-la"="ls -la"
alias "ls"="ls --color=auto"
alias "open=xdg-open"
alias ffs='sudo $(fc -ln  -1)'

# EXPORT ###############################################################
########################################################################

export EDITOR=nano
export PATH=~/.local/bin:$PATH
export TERM=xterm


clear

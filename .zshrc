# Lines configured by zsh-newuser-install
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dki/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall







bindkey    "^[[H"    beginning-of-line
bindkey    "^[[F"    end-of-line
bindkey    "^[[3~"    delete-char







###########################################################
local spacer=''
local abc=''


local coloruserfg='{black}'
local coloruserbg='{cyan}'
local colorpathfg='{black}'
local colorpathbg='{green}'
local colorfinalfg='{yellow}'
local colorfinalbg='{red}'
local colorjobsfg='{black}'
local colorjobsbg='{white}'
local colorgitfg='{black}'
local colorgitbg='{red}'

local oldfg=$coloruserfg
local oldbg=$coloruserbg


###########################################################
function jobsrunning(){
	#echo $(jobs -rp | wc -l)
	if [ $(jobs -rp | wc -l) -ne 0 ];
	then
		lnext $colorjobsfg $colorjobsbg
		echo $spacer $(jobs -rp | wc -l)
	fi
}

function gitinfo(){
	tmp=$(git symbolic-ref HEAD 2> /dev/null) 
	if [[ $tmp != '' ]];
	then
		lnext $colorgitfg $colorgitbg
		echo $spacer ${tmp#refs/heads/}
	fi
}

##########################################################



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






case "$TERM" in
	xterm*)
		oldfg=$coloruserfg
		oldbg=$coloruserbg

		PROMPT="%{%f%k%}%F"$coloruserfg"%K"$coloruserbg" %n" 
		rnext $colorpathfg $colorpathbg
		PROMPT+=$spacer" %1~"
		rnext '' %k
		PROMPT+=$spacer"%f%k "
		

		oldfg=''
		oldbg=''

		lnext $colorfinalfg $colorfinalbg

		setopt PROMPT_SUBST
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
#alias "ls"="ls --color=auto"
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

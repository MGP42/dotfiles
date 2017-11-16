# start some nice programs

# SSH-AGENT
eval $(ssh-agent)
ssh-add ~/.ssh/github


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

sxhkd -c ~/.config/bspwm/sxhkdrc &
exec bspwm
#exec startkde
#exec i3

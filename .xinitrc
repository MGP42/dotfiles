# start some nice programs
# export BROWSER=/usr/bin/chromium

export QT_QPA_PLATFORMTHEME=qt5ct
export TERMINAL=/usr/bin/termite

# SSH-AGENT
eval $(ssh-agent)

# CLOUD
syncthing --no-browser &

# XServer
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
xrdb load ~/.Xresources
numlockx &
sxhkd -c ~/.config/bspwm/sxhkdrc &
exec bspwm
#exec startkde
#exec i3

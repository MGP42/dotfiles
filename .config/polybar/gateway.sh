gateway=$(ip route | grep default | awk '{print $3}')

if [ -z $gateway ]; then
		echo " |"
else
		echo "%{A1:bash ~/.config/polybar/clipboard.sh gateway:}%{A2:xdg-open https\://$gateway:} $gateway%{A}%{A} |"
fi


#!/bin/bash
# Handle copies that do not work in polybar itself
# Mainly cause by having ':' in the string

wlan=$(nmcli device show | grep  "wifi" -B 1 | head -n 1 | cut -c 41-)
eth=$(nmcli device show | grep  "ethernet" -B 1 | head -n 1 | cut -c 41-)


case $1 in
wireless-mac)
    ip addr | grep $wlan -A 3 | grep link | xargs | cut -d " " -f 2 | tr -d '\n' | xclip -selection clipboard
    ;;
wireless-ipv6)
    ip -6 addr | grep $wlan -A 20 | grep fe80 -B2 | grep inet6 -m1 | xargs | cut -d " " -f 2 | cut -d "/" -f 1 | tr -d '\n' | xclip -selection clipboard
    ;;
public-ipv4)
    wget -q -O - ipinfo.io/ip | tr -d '\n' | xclip -selection clipboard
    notify-send public "ipv4 copied"
    ;;
ethernet-mac)
    ip addr | grep $eth -A 3 | grep link | xargs | cut -d " " -f 2 | tr -d '\n' | xclip -selection clipboard
    ;;
ethernet-ipv6)
    ip -6 addr | grep $eth -A 20 | grep fe80 -B2 | grep inet6 -m1 | xargs | cut -d " " -f 2 | cut -d "/" -f 1 | tr -d '\n' | xclip -selection clipboard
    ;;
gateway)
		ip route | grep default | awk '{print $3}' | xclip -selection clipboard
		notify-send public "gateway copied"
		;;
esac

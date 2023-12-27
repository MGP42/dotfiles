#!/bin/bash
# Handle copies that do not work in polybar itself
# Mainly cause by having ':' in the string

case $1 in
wireless-mac)
    ip addr | grep '[0-9]*: w' -A 3 | grep link | xargs | cut -d " " -f 2 | tr -d '\n' | xclip -selection clipboard
    ;;
wireless-ipv6)
    ip addr | grep '[0-9]*: w' -A 5 | grep inet6 | xargs | cut -d " " -f 2 | cut -d "/" -f 1 | tr -d '\n' | xclip -selection clipboard
    ;;
public-ipv4)
    wget -q -O - ipinfo.io/ip | tr -d '\n' | xclip -selection clipboard
    ;;
esac
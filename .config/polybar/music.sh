#!/bin/bash
case $1 in
# Controll Elements
control)
    mstat=$(playerctl status -a 2>/dev/null | grep -E "Playing|Paused")
    if [[ $mstat == "" ]]; then
        echo ""
        exit
    fi
    if [ $(playerctl status) == 'Playing' ]; then
        echo "%{A:playerctl previous:}%{A}  %{A:playerctl pause:}%{A}  %{A:playerctl next:}%{A}"
    else
        echo "%{A:playerctl previous:}%{A}  %{A:playerctl play:}%{A} %{A:playerctl next:}%{A}"
    fi
    ;;
# Song Info with zscroll
info)
    zartist=""
    ztitle="abc"
    while true; do
        mstat=$(playerctl status -a 2>/dev/null | grep -E "Playing|Paused")
        if [[ $mstat == "" ]]; then 
	    if [ -n "$pid" ]; then
                kill $pid
                unset pid
                unset zartist
                unset ztitle
            fi
        fi
        if [[ $mstat != "" ]]; then
            artist=$(playerctl metadata artist 2>/dev/null)
            title=$(playerctl metadata title 2>/dev/null)
            if [[ "$title" != "$ztitle" ]]; then
                if [ -n "$pid" ]; then
                    kill $pid
                fi
                zartist=$(playerctl metadata artist)
                ztitle=$(playerctl metadata title)
                zscroll -l20 -d0.3 "$artist - $title" &
                pid=$!
            fi
        fi
        if [ -z "$pid" ]; then
            echo ""
        fi
        sleep 1
    done
    ;;
# Separators Left/Right
sep_left)
    mstat=$(playerctl status -a 2>/dev/null | grep -E "Playing|Paused")
    if [[ $mstat != "" ]]; then
        echo ""
    else
        echo""
    fi
    ;;
sep_right)
    mstat=$(playerctl status -a 2>/dev/null | grep -E "Playing|Paused")
    if [[ $mstat != "" ]]; then
        echo ""
    else
        echo""
    fi

    ;;
esac

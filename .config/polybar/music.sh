#!/bin/bash
case $1 in
# Controll Elements
control)
    if [ -z $(playerctl status 2>/dev/null) ]; then
        echo ""
        exit
    fi
    if [ $(playerctl status) == 'Playing' ]; then
        echo "%{A:playerctl previous:}%{A}  %{A:playerctl pause:}%{A} %{A:playerctl next:}%{A}"
    else
        echo "%{A:playerctl previous:}%{A}  %{A:playerctl play:}%{A} %{A:playerctl next:}%{A}"
    fi
    ;;
# Song Info with zscroll
info)
    zartist=""
    ztitle=""
    while true; do
        if [ "$(playerctl status 2>/dev/null)" = "" ] && [ -n "$pid" ]; then
            kill $pid
            unset pid
            unset zartist
            unset ztitle
        fi
        if [ "$(playerctl status 2>/dev/null)" != "" ]; then
            artist=$(playerctl metadata artist 2>/dev/null)
            title=$(playerctl metadata title 2>/dev/null)
            if [ "$title" != "$ztitle" ]; then
                if [ -n "$pid" ]; then
                    kill $pid
                fi
                zartist=$(playerctl metadata artist)
                ztitle=$(playerctl metadata title)
                zscroll -l20 "$artist - $title" &
                pid=$!
            fi
        fi
        if [ -z "$zartist" ]; then
            echo ""
        fi
        sleep 1
    done
    ;;
# Separators Left/Right
sep_left)
    if [ "$(playerctl status 2>/dev/null)" != "" ]; then
        echo ""
    else
        echo""
    fi
    ;;
sep_right)
    if [ "$(playerctl status 2>/dev/null)" != "" ]; then
        echo ""
    else
        echo""
    fi

    ;;
esac

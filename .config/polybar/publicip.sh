#!/bin/bash

# Fetch data from ipinfo.io
result=$(wget -qO- ipinfo.io/ip)

# Check if the result contains only one line
if [ $(echo "$result" | wc -l) -eq 1 ]; then
    echo "%{A1:bash ~/.config/polybar/clipboard.sh public-ipv4:}$result%{A}"
else
    # Extract all web addresses using grep and sed
	addresses=$(echo "$result" | grep -oP '(https?://[^\s<"]+)' | sed "s/:/'\\\\:'/g")

    # Format the addresses
    formatted=$(echo "$addresses" | while read -r line; do
        echo -n "%{A1:xdg-open $line:}%{A} "
    done)

    # Output formatted result
    echo "$formatted"
fi


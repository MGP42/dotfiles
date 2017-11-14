dropdown="$(cat $(dirname $0)/active)"
	if [ "$dropdown" != "none" ]; then
                killall conky-dropdown
        fi
        if [ "$dropdown" != "$1" ]; then
                $(dirname $0)/conky-dropdown -qc $(dirname $0)/$1
                dropdown="$1"
        else
                dropdown="none"
        fi
echo $dropdown > $(dirname $0)/active &

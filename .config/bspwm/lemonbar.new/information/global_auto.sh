. $(dirname $0)/../path.conf
 
Conky(){
    conky -c $(dirname $0)/global_conky | while read -r line; do
        index=$(echo $line | cut -d\\ -f1)
        value=$(echo $line | cut -d\\ -f2)
        case $index in
            (memory)
                sed -i "6s/.*/$(echo ram=\'$(echo $value)\')/" $memory""global;;
            (network)
                sed -i "7s/.*/$(echo net_up=\'$(echo $value | cut -d+ -f1)\')/" $memory""global
                sed -i "8s/.*/$(echo net_down=\'$(echo $value | cut -d+ -f2)\')/" $memory""global;;
            (cpu)
                sed -i "5s/.*/$(echo cpu=\'$(echo $value)\%\')/" $memory""global;;
        esac
    done
}

Slow(){
    while true;do
        sed -i "1s/.*/$(echo time=\'$(date +%H:%M)\')/" $memory""global
        sed -i "2s/.*/$(echo date=\'$(date "+%a %d %b")\')/" $memory""global
        sed -i "4s/.*/$(echo battery=\'$(acpi --battery | cut -d, -f2 | cut -d' ' -f2)\')/" $memory""global
        #sed -i "2s/.*/$(echo =\'\')/" $memory""global

        sleep 10
    done
}

Conky &
Slow 

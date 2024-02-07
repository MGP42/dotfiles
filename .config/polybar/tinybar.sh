path=/dev/shm/tinybar.$USER.running

if [ -e $path ]
then
	type=$(head -n 1 $path)
	for id in $(tail +2 $path)
	do
		kill $id
	done
fi

if [ $1 == $type ] || [ $1 == 'kill' ]
then
  rm $path
else
	echo $1 > $path
	for m in $(polybar --list-monitors | cut -d":" -f1)
	do
		MONITOR=$m polybar -c ~/.config/polybar/tinybar.ini $1 &
		echo $! >> $path
	done
fi

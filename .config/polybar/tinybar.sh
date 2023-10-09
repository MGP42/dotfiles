path=~/.cache/tinybar.running

if [ -e $path ]
then
  pid=$(head -n 1 $path)
  type=$(sed -n '2p' $path)
  kill $pid
fi

echo $type
echo $1
echo ""
if [ $1 == $type ] || [ $1 == 'kill' ]
then
  rm $path
else
  echo start
  polybar -c ~/.config/polybar/tinybar.ini $1 &
  echo $! > $path
  echo $1 >> $path
fi

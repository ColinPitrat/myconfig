#!/bin/bash

round()
{
  echo "(($1+5)/10)*10" | bc
}

# Retrieve the backlight level
blset=$(xbacklight)
echo "BL: $blset"
blset=`round $blset`
echo "BL: $blset"

text="Backlight: ${blset}%"

OSDCOLOR=green

# Clean up any running aosd_cat processes
to_kill=`ps aux | grep osd_cat | awk '{ print $2 }' | xargs`
#killall osd_cat &> /dev/null

# Display the result
osd_cat -d 1 -p middle -A center -b percentage -P $blset -T "$text" -c $OSDCOLOR -f *-*-*-*-*-*-*-32-* &
sleep 0.2

kill -9 $to_kill

# END

#!/bin/bash

# Retrieve the volume
volset=$(pactl list sources | grep "^\s*Volume:" | tail -n 1 | cut -d : -f 3 | cut -d % -f 1)

# Retrieve the mute status
mutestatus=$(pactl list sources | grep Mute | tail -n 1 | cut -d : -f 2)

text="Mic. volume: ${volset}%"

if [ $mutestatus == "yes" ]; then
   OSDCOLOR=red;
   text="$text (Muted)"
else
   OSDCOLOR=green
fi

# Clean up any running aosd_cat processes
to_kill=`ps aux | grep osd_cat | awk '{ print $2 }' | xargs`
#killall osd_cat &> /dev/null

# Display the result
osd_cat -d 1 -p middle -A center -b percentage -P $volset -T "$text" -c $OSDCOLOR -f *-*-*-*-*-*-*-32-* &
sleep 0.2

kill -9 $to_kill

# END
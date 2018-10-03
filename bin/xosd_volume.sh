#!/bin/bash

# Retrieve the volume
volset=$(pactl list sinks | grep "^\s*Volume:" | tail -n 1 | sed 's/.*\s\([0-9]*\)%.*/\1/')

# Retrieve the mute status
mutestatus=$(pactl list sinks | grep Mute | tail -n 1 | cut -d : -f 2)

text="Volume: ${volset}%"

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
osd_cat -d 1 -p middle -A center -b percentage -P $volset -T "$text" -c $OSDCOLOR -f *-*-*-*-*-*-*-24-* &
sleep 0.2

kill -9 $to_kill

# END

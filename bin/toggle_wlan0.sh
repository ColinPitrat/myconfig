#!/bin/sh

wlan0_status=""
OSDCOLOR=""
if ifconfig | grep wlan0 > /dev/null
then
  ifconfig wlan0 down
  wlan0_status="off"
  OSDCOLOR=red
else
  ifconfig wlan0 up
  wlan0_status="on"
  OSDCOLOR=green
fi

# Clean up any running aosd_cat processes
to_kill=`ps aux | grep osd_cat | awk '{ print $2 }' | xargs`

# Display the result
osd_cat -d 1 -p middle -A center -T "WiFi: $wlan0_status" -c $OSDCOLOR -f *-*-*-*-*-*-*-24-* &
sleep 0.2

kill -9 $to_kill

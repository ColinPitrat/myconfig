#!/bin/sh

charge_now=`cat /sys/class/power_supply/BAT0/energy_now`
charge_full=`cat /sys/class/power_supply/BAT0/energy_full`
charge=`echo 100*${charge_now}/${charge_full} | bc`
status=`cat /sys/class/power_supply/BAT0/status`

if [ $charge -lt 15 -a "$status" != "Charging" ]
then
  export DISPLAY=:0.0
  zenity --warning --title "Fais gaffe !" --text "Bientôt plus de batterie mec !" &
  # Repeat multiple times just in case I miss it
  for i in `seq 1 3`
  do
    # Play multiple sounds as the presence of the files depend on the computer ...
    mplayer /usr/share/sounds/KDE-Sys-App-Error-Serious-Very.ogg /usr/share/sounds/ubuntu/stereo/message-new-instant.ogg
    sleep 5
  done
fi

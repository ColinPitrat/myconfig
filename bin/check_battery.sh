#!/bin/sh

charge_now=`cat /sys/class/power_supply/BAT0/energy_now`
charge_full=`cat /sys/class/power_supply/BAT0/energy_full`
charge=`echo 100*${charge_now}/${charge_full} | bc`
status=`cat /sys/class/power_supply/BAT0/status`

if [ $charge -lt 15 -a "$status" != "Charging" ]
then
  export DISPLAY=:0.0
  zenity --warning --title "Fais gaffe !" --text "Bientôt plus de batterie mec !" &
  mplayer /usr/share/sounds/KDE-Sys-App-Error-Serious-Very.ogg
  sleep 5
  mplayer /usr/share/sounds/KDE-Sys-App-Error-Serious-Very.ogg
  sleep 5
  mplayer /usr/share/sounds/KDE-Sys-App-Error-Serious-Very.ogg
fi

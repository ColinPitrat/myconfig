#!/bin/bash

zenity --question --title "Shutdown" --text "Shutdown computer ?"

if [ $? -eq 0 ]
then
	xterm -e "sudo shutdown -h now"
fi

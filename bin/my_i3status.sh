#!/bin/bash
i3status | while :
do
  read line
  echo $line | \
    sed 's/\("full_text":"MTV: \)/"color":"#FFFF00",\1/' | \
    sed 's/\("full_text":"DUB: \)/"color":"#8080FF",\1/'
done

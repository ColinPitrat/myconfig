#!/bin/bash
i3status | while :
do
  read line
  swap_usage=`echo 100-100*$(grep SwapFree /proc/meminfo | awk '{ print $2 }')/$(grep SwapTotal /proc/meminfo | awk '{ print $2 }') | bc`
  swap_stanza='{"name":"swap","color":"#FFFFFF","markup":"none","full_text":"'$swap_usage'%"}'
  echo $line | \
    sed 's/\("full_text":"MTV: \)/"color":"#FFFF00",\1/' | \
    sed 's/\("full_text":"DUB: \)/"color":"#8080FF",\1/' | \
    sed "s/\[{/\[${swap_stanza}{/"
done

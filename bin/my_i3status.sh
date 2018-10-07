#!/bin/bash

function make_stanza() {
  stanza_name=$1
  stanza_value=$2
  echo '{"name":"'$stanza_name'","color":"#FFFFFF","markup":"none","full_text":"'$stanza_value'"}'
}

i3status | while :
do
  read line
  mem_usage=`echo 100-100*$(grep MemFree /proc/meminfo | awk '{ print $2 }')/$(grep MemTotal /proc/meminfo | awk '{ print $2 }') | bc`
  mem_stanza=`make_stanza "mem", "M: $mem_usage%"`
  swap_usage=`echo 100-100*$(grep SwapFree /proc/meminfo | awk '{ print $2 }')/$(grep SwapTotal /proc/meminfo | awk '{ print $2 }') | bc`
  swap_stanza=`make_stanza "swap", "S: $swap_usage%"`
  echo $line | \
    sed 's/\("full_text":"MTV: \)/"color":"#FFFF00",\1/' | \
    sed 's/\("full_text":"DUB: \)/"color":"#8080FF",\1/' | \
    sed "s/\[{/\[${mem_stanza},${swap_stanza},{/"
done

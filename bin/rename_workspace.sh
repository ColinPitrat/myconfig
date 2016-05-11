#!/bin/bash

workspace_num=`i3-msg -t get_workspaces | sed 's/,/\n/g' | grep '\(num\|focused.:true\)' | grep -B 1 focused | grep num | cut -d : -f 2`
i3-input -F "rename workspace to \"$workspace_num: %s\"" -P "New name: "

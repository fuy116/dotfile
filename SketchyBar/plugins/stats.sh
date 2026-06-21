#!/bin/sh

PROCS=$(ps -e 2>/dev/null | wc -l | tr -d ' ')
LOAD=$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')
TOP_LINE=$(ps -ax -o comm= -o %cpu= 2>/dev/null | awk '{cpu=$NF; $NF=""; gsub(/^ +| +$/,""); gsub(/.*\//,""); print $0, cpu}' | sort -k2 -nr | head -1)
TOP_NAME=$(echo "$TOP_LINE" | awk '{print $1}' | cut -c1-14)
TOP_CPU=$(echo "$TOP_LINE" | awk '{printf "%.0f", $2}')

sketchybar --set "$NAME" label="${PROCS} ${LOAD} ${TOP_NAME} ${TOP_CPU}%"

#!/bin/sh

CPU=$(ps -A -o %cpu= 2>/dev/null | awk '{s+=$1} END {printf "%.2f", s/100}')
[ -z "$CPU" ] && CPU=0.05

sketchybar --push "$NAME" "$CPU"

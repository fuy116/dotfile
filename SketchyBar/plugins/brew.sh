#!/bin/sh

COUNT=$( (brew outdated --formula 2>/dev/null; brew outdated --cask 2>/dev/null) | sort -u | wc -l | tr -d ' ')

sketchybar --set "$NAME" icon="󰏖" label="$COUNT"

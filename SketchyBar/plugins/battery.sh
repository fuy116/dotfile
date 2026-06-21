#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹" ;;
  [6-8][0-9]) ICON="󰂁" ;;
  [3-5][0-9]) ICON="󰁿" ;;
  [1-2][0-9]) ICON="󰁻" ;;
  *)          ICON="󰁺" ;;
esac

[ -n "$CHARGING" ] && ICON="󰂄"

# icon 顏色：正常綠、充電琥珀、低電量(<=20%)紅；數字維持深色
COLOR=0xff8fa884
if [ -n "$CHARGING" ]; then
  COLOR=0xffc7a86e
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR=0xffc28a7c
fi

sketchybar --set "$NAME" \
  icon="$ICON" icon.color="$COLOR" \
  label="${PERCENTAGE}%" label.color=0xff2c2c2e \
  label.font="JetBrainsMono Nerd Font:Bold:12.0"

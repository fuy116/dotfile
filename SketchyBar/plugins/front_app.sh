#!/bin/sh

source "$CONFIG_DIR/plugins/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  __icon_map "$INFO"
  sketchybar --set "$NAME" \
    icon="$icon_result" \
    icon.drawing=on \
    icon.font="sketchybar-app-font:Regular:16.0" \
    label="$INFO"
fi

#!/bin/sh

if [ "$SENDER" = "front_app_switched" ] && [ "$SELECTED" != "true" ]; then
  exit 0
fi

source "$CONFIG_DIR/plugins/icon_map.sh"

BRACKET="space.bracket.${SID}"

if [ "$SELECTED" = "true" ]; then
  APPS=$(osascript -e 'tell application "System Events"
    set output to ""
    repeat with p in (every application process whose visible is true and background only is false)
      set output to output & name of p & linefeed
    end repeat
    return output
  end tell' 2>/dev/null | head -5)

  ICONS=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    ICONS="${ICONS}${icon_result}"
  done <<EOF
$APPS
EOF

  sketchybar --set "$NAME" \
    icon.highlight=on \
    icon.color=0xffff5555 \
    label="$ICONS" \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.drawing=on

  sketchybar --set "$BRACKET" \
    background.drawing=on \
    background.color=0x45ffffff \
    background.corner_radius=6 \
    background.height=24
else
  sketchybar --set "$NAME" \
    icon.highlight=off \
    icon.color=0xffcccccc \
    label.drawing=off

  sketchybar --set "$BRACKET" background.drawing=off
fi

#!/bin/sh
# AeroSpace workspace 指示器（單色 app-font 圖示）
# 由 sketchybarrc 以 $1 = workspace id 呼叫
# 訂閱事件：aerospace_workspace_change, front_app_switched

source "$CONFIG_DIR/plugins/icon_map.sh"

SID="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
BRACKET="space.bracket.${SID}"

# 該 workspace 開著的 App（去重）
APPS=$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | awk '!seen[$0]++')

if [ "$SID" = "$FOCUSED" ]; then
  # 聚焦中：紅字 + 高亮框 + 該空間 App 的單色圖示
  ICONS=""
  while IFS= read -r app; do
    [ -z "$app" ] && continue
    __icon_map "$app"
    ICONS="${ICONS}${icon_result}"
  done <<EOF
$APPS
EOF

  sketchybar --set "$NAME" \
    drawing=on \
    icon.highlight=on \
    icon.color=0xffff5555 \
    label="$ICONS" \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.color=0xff2c2c2e \
    label.drawing=on

  sketchybar --set "$BRACKET" \
    background.drawing=on \
    background.color=0x26000000 \
    background.corner_radius=6 \
    background.height=24

elif [ -n "$APPS" ]; then
  # 沒聚焦但有開視窗：深色數字、無框、不顯示圖示
  sketchybar --set "$NAME" \
    drawing=on \
    icon.highlight=off \
    icon.color=0xff48484a \
    label.drawing=off
  sketchybar --set "$BRACKET" background.drawing=off

else
  # 空 workspace：隱藏
  sketchybar --set "$NAME" drawing=off
  sketchybar --set "$BRACKET" background.drawing=off
fi

#!/bin/sh
# 倒數日：距離目標日期還有幾天（資工所考試）
TARGET="2027-02-01"

target_epoch=$(date -j -f "%Y-%m-%d %H:%M:%S" "$TARGET 00:00:00" "+%s" 2>/dev/null)
today="$(date '+%Y-%m-%d')"
today_epoch=$(date -j -f "%Y-%m-%d %H:%M:%S" "$today 00:00:00" "+%s" 2>/dev/null)

[ -z "$target_epoch" ] && exit 0
days=$(( (target_epoch - today_epoch) / 86400 ))

if [ "$days" -gt 0 ]; then
  LABEL="D-${days}"
elif [ "$days" -eq 0 ]; then
  LABEL="D-DAY"
else
  LABEL="D+$(( -days ))"
fi

# 越接近越警示：<=30 天紅、<=90 天橘、其餘深色
COLOR=0xff2c2c2e
if [ "$days" -le 30 ]; then
  COLOR=0xffc28a7c
elif [ "$days" -le 90 ]; then
  COLOR=0xffc7a86e
fi

sketchybar --set "$NAME" icon.color=0xffc28a7c label="$LABEL" label.color="$COLOR"

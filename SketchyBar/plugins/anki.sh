#!/bin/sh
# Anki 備考：今日已複習卡片數（AnkiConnect，需 Anki 開著 + AnkiConnect 套件）
# 連不上 / Anki 沒開 → 隱藏整格

ANKI_REQ() {
  curl -s -m 1 -X POST http://127.0.0.1:8765 -d "$1" 2>/dev/null
}

DONE_JSON=$(ANKI_REQ '{"action":"getNumCardsReviewedToday","version":6}')

# 連不上 → 隱藏
if [ -z "$DONE_JSON" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

DONE=$(printf '%s' "$DONE_JSON" | python3 -c "import sys,json
try:
    r=json.load(sys.stdin).get('result')
    print(r if isinstance(r,int) else -1)
except Exception:
    print(-1)" 2>/dev/null)

# 解析失敗 → 隱藏
if [ -z "$DONE" ] || [ "$DONE" = "-1" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

sketchybar --set "$NAME" drawing=on label="$DONE"

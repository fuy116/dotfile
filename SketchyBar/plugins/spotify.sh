#!/usr/bin/env bash

COVER="/tmp/cover.jpg"

next() { osascript -e 'tell application "Spotify" to next track' 2>/dev/null; }
back() { osascript -e 'tell application "Spotify" to previous track' 2>/dev/null; }
play() { osascript -e 'tell application "Spotify" to playpause' 2>/dev/null; }

spotify_running() { pgrep -x "Spotify" >/dev/null 2>&1; }

truncate() {
  printf '%s' "$1" | LANG=en_US.UTF-8 sed "s/\(.\{$2\}\).*/\1…/"
}

fetch_state() {
  osascript -e 'tell application "Spotify" to return (name of current track) & "|" & (artist of current track) & "|" & (album of current track) & "|" & (player state as text) & "|" & (artwork url of current track)' 2>/dev/null
}

update() {
  if ! spotify_running; then
    sketchybar --set spotify drawing=off popup.drawing=off
    return
  fi

  STATE=""; TRACK=""; ARTIST=""; ALBUM=""; COVER_URL=""

  if [ -n "$INFO" ] && [ "$INFO" != "null" ]; then
    STATE=$(echo "$INFO" | jq -r '.["Player State"] // empty')
    TRACK=$(echo "$INFO" | jq -r '.Name // empty')
    ARTIST=$(echo "$INFO" | jq -r '.Artist // empty')
    ALBUM=$(echo "$INFO" | jq -r '.Album // empty')
  fi

  if [ -z "$TRACK" ]; then
    IFS='|' read -r TRACK ARTIST ALBUM STATE COVER_URL <<< "$(fetch_state)"
  fi

  if [ -z "$COVER_URL" ]; then
    COVER_URL=$(osascript -e 'tell application "Spotify" to get artwork url of current track' 2>/dev/null)
  fi

  if [ -z "$TRACK" ]; then
    sketchybar --set spotify drawing=off popup.drawing=off
    return
  fi

  [ -n "$COVER_URL" ] && [ "$COVER_URL" != "missing value" ] && \
    curl -sfL --max-time 15 "$COVER_URL" -o "$COVER"

  case "$STATE" in
    [Pp]laying) PLAY_ICON="󰏤" ;;
    *)          PLAY_ICON="󰐊" ;;
  esac

  BAR_LABEL="$TRACK"
  [ -n "$ARTIST" ] && BAR_LABEL="$TRACK — $ARTIST"

  T_TITLE=$(truncate "$TRACK" 18)
  T_ARTIST=$(truncate "$ARTIST" 20)
  T_ALBUM=$(truncate "$ALBUM" 20)

  sketchybar --set spotify drawing=on icon=󰓇 icon.color=0xff1DB954 label="$BAR_LABEL" \
             --set spotify.title  label="$T_TITLE"  drawing=on \
             --set spotify.artist label="$T_ARTIST" drawing=on \
             --set spotify.album  label="$T_ALBUM"  drawing=on \
             --set spotify.play   icon="$PLAY_ICON" \
             --set spotify.cover  background.image="$COVER" background.color=0x00000000
}

popup() { sketchybar --set spotify popup.drawing="$1"; }

mouse_clicked() {
  case "$NAME" in
    spotify.next) next ;;
    spotify.back) back ;;
    spotify.play) play ;;
  esac
}

case "$SENDER" in
  mouse.clicked) mouse_clicked ;;
  mouse.entered) popup on ;;
  mouse.exited|mouse.exited.global) popup off ;;
  *) update ;;
esac

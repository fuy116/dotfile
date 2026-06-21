#!/usr/bin/env bash
# Claude Code 5h 用量與重置倒數
# 資料來源：Keychain OAuth token → api.anthropic.com/api/oauth/usage
# 快取 5 分鐘，避免 API rate limit

CACHE_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}/cache"
CACHE_FILE="$CACHE_DIR/claude-usage.json"
CACHE_TTL="${CLAUDE_USAGE_CACHE_TTL:-300}"

mkdir -p "$CACHE_DIR"

result=$(python3 - "$CACHE_FILE" "$CACHE_TTL" <<'PY'
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone

cache_file = sys.argv[1]
cache_ttl = int(sys.argv[2])
LABEL_COLOR = "0xff48484a"


def fmt_remaining(value) -> str:
    if value is None:
        return ""
    if isinstance(value, (int, float)):
        ts = float(value)
        if ts > 1e12:
            ts /= 1000.0
        dt = datetime.fromtimestamp(ts, tz=timezone.utc)
    else:
        dt = datetime.fromisoformat(str(value).replace("Z", "+00:00"))
    secs = int((dt - datetime.now(timezone.utc)).total_seconds())
    if secs <= 0:
        return "0m"
    h, rem = divmod(secs, 3600)
    m = rem // 60
    if h:
        return f"{h}h{m:02d}m"
    return f"{m}m"


def pct(value) -> int:
    try:
        return max(0, min(100, round(float(value))))
    except (TypeError, ValueError):
        return 0


def load_cache():
    try:
        with open(cache_file, encoding="utf-8") as f:
            data = json.load(f)
        if time.time() - data.get("fetched_at", 0) <= cache_ttl:
            return data
    except (OSError, json.JSONDecodeError, TypeError):
        pass
    return None


def save_cache(payload: dict) -> None:
    payload["fetched_at"] = time.time()
    tmp = cache_file + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(payload, f)
    os.replace(tmp, cache_file)


def fetch_token() -> str | None:
    try:
        raw = subprocess.check_output(
            [
                "security",
                "find-generic-password",
                "-s",
                "Claude Code-credentials",
                "-a",
                os.environ.get("USER", ""),
                "-w",
            ],
            stderr=subprocess.DEVNULL,
            text=True,
        )
        creds = json.loads(raw)
        return creds.get("claudeAiOauth", {}).get("accessToken")
    except (subprocess.CalledProcessError, json.JSONDecodeError, OSError):
        return None


def fetch_usage(token: str) -> dict:
    req = urllib.request.Request(
        "https://api.anthropic.com/api/oauth/usage",
        headers={
            "Authorization": f"Bearer {token}",
            "anthropic-beta": "oauth-2025-04-20",
            "User-Agent": "sketchybar-claude-usage/1.0",
        },
    )
    with urllib.request.urlopen(req, timeout=15) as resp:
        return json.load(resp)


def build_label(data: dict) -> str:
    five = data.get("five_hour") or {}
    five_pct = pct(five.get("utilization", five.get("used_percentage")))
    five_reset = fmt_remaining(five.get("resets_at"))

    label = f"5h {five_pct}%"
    if five_reset:
        label += f" ↺{five_reset}"
    return label


cached = load_cache()
if cached and "label" in cached:
    print(json.dumps({"label": cached["label"], "color": LABEL_COLOR, "ok": True}))
    raise SystemExit(0)

token = fetch_token()
if not token:
    print(json.dumps({"label": "CC login", "color": LABEL_COLOR, "ok": False}))
    raise SystemExit(0)

try:
    usage = fetch_usage(token)
    label = build_label(usage)
    save_cache({"label": label, "color": LABEL_COLOR, "raw": usage})
    print(json.dumps({"label": label, "color": LABEL_COLOR, "ok": True}))
except urllib.error.HTTPError:
    stale = None
    try:
        with open(cache_file, encoding="utf-8") as f:
            stale = json.load(f)
    except (OSError, json.JSONDecodeError):
        pass
    if stale and stale.get("label"):
        print(json.dumps({"label": stale["label"], "color": LABEL_COLOR, "ok": True}))
    else:
        print(json.dumps({"label": "CC err", "color": LABEL_COLOR, "ok": False}))
except Exception:
    print(json.dumps({"label": "CC --", "color": LABEL_COLOR, "ok": False}))
PY
)

label=$(echo "$result" | python3 -c 'import json,sys; print(json.load(sys.stdin)["label"])')
color=$(echo "$result" | python3 -c 'import json,sys; print(json.load(sys.stdin)["color"])')

sketchybar --set "$NAME" \
  icon=":claude:" \
  icon.drawing=on \
  icon.font="sketchybar-app-font:Regular:14.0" \
  icon.color=0xffDA7756 \
  icon.padding_right=4 \
  label="$label" \
  label.color="$color" \
  label.font="JetBrainsMono Nerd Font:Bold:11.0"

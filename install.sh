#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$ROOT/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"

echo "Done. Reload AeroSpace: aerospace reload-config (or Alt+Shift+R)"

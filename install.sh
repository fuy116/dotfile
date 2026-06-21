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
link "$ROOT/oh-my-posh/theme.omp.json" "$HOME/.config/oh-my-posh/theme.omp.json"
link "$ROOT/ghostty/config" "$HOME/.config/ghostty/config"

echo "Done."
echo "  AeroSpace: Alt+Shift+R 或 aerospace reload-config"
echo "  Ghostty:   重開 terminal 或新開視窗"
echo "  oh-my-posh: exec zsh 或開新 terminal"

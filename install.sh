#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# If ~/.config doesn't exist, symlink the whole repo
if [ ! -e "$CONFIG_HOME" ]; then
  ln -sf "$DOTFILES_DIR" "$CONFIG_HOME"
else
  # Symlink each top-level directory from the repo into ~/.config
  for item in "$DOTFILES_DIR"/*/; do
    name="$(basename "$item")"
    target="$CONFIG_HOME/$name"
    if [ ! -e "$target" ]; then
      ln -sf "$item" "$target"
    fi
  done
  # Also link top-level dotfiles
  for item in "$DOTFILES_DIR"/.*; do
    name="$(basename "$item")"
    [ "$name" = "." ] || [ "$name" = ".." ] || [ "$name" = ".git" ] && continue
    target="$CONFIG_HOME/$name"
    if [ ! -e "$target" ]; then
      ln -sf "$item" "$target"
    fi
  done
fi

# Initialize git submodules
git -C "$DOTFILES_DIR" submodule update --init --recursive 2>/dev/null || true

# Source bash profile from ~/.bashrc if not already configured
BASHRC="$HOME/.bashrc"
SOURCE_LINE="source \"$CONFIG_HOME/bash/profile\""
if [ -f "$BASHRC" ]; then
  grep -qF "bash/profile" "$BASHRC" || echo "$SOURCE_LINE" >> "$BASHRC"
else
  echo "$SOURCE_LINE" > "$BASHRC"
fi

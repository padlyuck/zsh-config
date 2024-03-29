#!/usr/bin/env bash

set -euo pipefail

PWD=$(pwd)
INSTALL_DIR="$HOME/.oh-my-zsh"
CONFIG_FILES=(
  ".zshrc.local"
  ".tmux.conf"
  ".zsh_plugins"
  ".zsh_aliases"
  ".config/aria2"
  ".config/k9s"
  ".config/nano"
  ".config/regolith2"
  ".config/youtube-dl"
  ".config/user-dirs.dirs"
)
LOCAL_BIN_PATH="$HOME/.local/bin"

for TARGET_PATH in "$PWD"/custom/plugins/*; do
  TARGET_NAME="$(basename "$TARGET_PATH")"
  LINK="$INSTALL_DIR/custom/plugins/$TARGET_NAME"
  if [[ ! -L $LINK ]]; then
    ln -sf "$TARGET_PATH" "$LINK"
  fi
done

for TARGET_PATH in "$PWD"/custom/themes/*; do
  TARGET_NAME="$(basename "$TARGET_PATH")"
  LINK="$INSTALL_DIR/custom/themes/$TARGET_NAME"
  if [[ ! -L $LINK ]]; then
    ln -sf "$TARGET_PATH" "$LINK"
  fi
done

mkdir -p "$LOCAL_BIN_PATH"
for TARGET_PATH in "$PWD"/bin/*; do
  TARGET_NAME="$(basename "$TARGET_PATH")"
  LINK="$LOCAL_BIN_PATH/$TARGET_NAME"
  if [[ ! -L $LINK ]]; then
    ln -sf "$TARGET_PATH" "$LINK"
  fi
done

for fileName in "${CONFIG_FILES[@]}"; do
  TARGET_PATH="$PWD/$fileName"
  LINK="$HOME/$fileName"
  mkdir -p "$(dirname "$LINK")"
  if [[ ! -L $LINK ]]; then
    ln -s "$TARGET_PATH" "$LINK"
  fi
done

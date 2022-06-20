#!/usr/bin/env bash

set -euo pipefail

PWD=$(pwd)
INSTALL_DIR="$HOME/.oh-my-zsh"
CONFIG_FILES=(
  ".zshrc.local"
  ".tmux.conf"
  ".zsh_plugins"
  ".zsh_aliases"
  ".config/nano"
)
LOCAL_BIN_PATH="$HOME/.local/bin"

git submodule init
git submodule update

if [[ -d "$INSTALL_DIR" ]]; then
  mv "$INSTALL_DIR" "$INSTALL_DIR.bak"
fi

for fileName in "${CONFIG_FILES[@]}"; do
  if [[ -r "$HOME/$fileName" ]]; then
    mv "$HOME/$fileName" "$HOME/$fileName.bak"
  fi
done

git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"

if [[ -e "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

for PLUGIN_PATH in "$PWD"/custom/plugins/*; do
  PLUGIN_NAME="$(basename "$PLUGIN_PATH")"
  ln -s "$PLUGIN_PATH" "$INSTALL_DIR/custom/plugins/$PLUGIN_NAME"
done

for THEME_PATH in "$PWD"/custom/themes/*; do
  THEME_NAME="$(basename "$THEME_PATH")"
  ln -s "$THEME_PATH" "$INSTALL_DIR/custom/themes/$THEME_NAME"
done

mkdir -p "$LOCAL_BIN_PATH"
for BINARY_PATH in "$PWD"/bin/*; do
  BINARY_NAME="$(basename "$BINARY_PATH")"
  ln -s "$BINARY_PATH" "$LOCAL_BIN_PATH/$BINARY_NAME"
done

for fileName in "${CONFIG_FILES[@]}"; do
  mkdir -p $(dirname "$LINK")
  ln -s "$PWD/$fileName" "$HOME/$fileName"
  if [[ -r "$HOME/$fileName.bak" ]]; then
    echo ""
    echo "$HOME/$fileName.bak >>>> $HOME/$fileName"
    diff "$HOME/$fileName.bak" "$HOME/$fileName"
    echo "====================="
  fi
done

cp "$INSTALL_DIR/templates/zshrc.zsh-template" "$HOME/.zshrc"

sed -E "s/^source\ \\\$ZSH\/oh-my-zsh.sh$//g" -i "$HOME/.zshrc"

echo -e "[[ -r \"\$HOME/.zshrc.local\" ]] && source \"\$HOME/.zshrc.local\"" >>"$HOME/.zshrc"

chsh -s /bin/zsh "$(whoami)"

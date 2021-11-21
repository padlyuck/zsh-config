#!/usr/bin/env bash

set -euo pipefail

PWD=$(pwd)
INSTALL_DIR="$HOME/.oh-my-zsh"

if [[ -d "$INSTALL_DIR" ]]; then
  mv "$INSTALL_DIR" "$INSTALL_DIR.bak"
fi

git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"

if [[ -e "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

git clone https://github.com/popstas/zsh-command-time.git "$PWD/custom/plugins/command-time"

for PLUGIN_PATH in "$PWD"/custom/plugins/*; do
  PLUGIN_NAME="$(basename "$PLUGIN_PATH")"
  ln -s "$PLUGIN_PATH" "$INSTALL_DIR/custom/plugins/$PLUGIN_NAME"
done

for THEME_PATH in "$PWD"/custom/themes/*; do
  THEME_NAME="$(basename "$THEME_PATH")"
  ln -s "$THEME_PATH" "$INSTALL_DIR/custom/themes/$THEME_NAME"
done

ln -s "$PWD/.zshrc.local" "$HOME/.zshrc.local"
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"

cp "$PWD/.zsh_plugins" "$HOME/.zsh_plugins"
cp "$PWD/.zsh_aliases" "$HOME/.zsh_aliases"
cp "$INSTALL_DIR/templates/zshrc.zsh-template" "$HOME/.zshrc"

sed -E "s/^source\ \\\$ZSH\/oh-my-zsh.sh$//g" -i "$HOME/.zshrc"

echo -e "[[ -r \"\$HOME/.zshrc.local\" ]] && source \"\$HOME/.zshrc.local\"" >> "$HOME/.zshrc"

chsh -s /bin/zsh "$(whoami)"

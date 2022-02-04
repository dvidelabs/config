#!/bin/bash

# Assume zsh is already installed, or will be.
# Assume ~/.zshrc is installed or will be.
# oh-my-zsh install script would overwrite .zshrc.

# Install oh-my-zsh:
if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
ZSH_PLUGIN_URL=https://github.com/zsh-users

# This does not enable custom plugins so they need not be platform specific.
zsh_install_plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)

for plugin in ${zsh_install_plugins[*]}; do
  echo "processing fish plugin: $plugin"
  if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    git clone $ZSH_PLUGIN_URL/$plugin $ZSH_CUSTOM/plugins/$plugin
    chmod 700 $ZSH_CUSTOM/plugins/$plugin
  fi
done

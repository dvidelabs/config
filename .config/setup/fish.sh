#!/bin/bash -e
# install fisher plugin manager

[ "$(which fish)" ] || exit 1

# Install fisher plugin manager for fish
if [ ! -e ~/.config/fish/functions/fisher.fish ] ; then
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fi

# More Fish plugins:
# https://awesomeopensource.com/projects/fish-plugin/fisher

fish_install_plugins=(
    jorgebucaran/fisher
    jethrokuan/z
)

if [ -e ~/.config/fish/functions/fisher.fish ]; then
    for plugin in ${fish_install_plugins[*]}; do
        echo "processing zsh plugin: $plugin"
        fish -c "fisher install $plugin"
    done
fi

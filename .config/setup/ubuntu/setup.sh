#!/bin/bash

SETUP=$(dirname $0)/..

sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt-add-repository ppa:git-core/ppa -y

sudo apt-get update
sudo apt-get -y install curl tmux git fish zsh silversearcher-ag

$SETUP/vim.sh
$SETUP/zsh.sh
$SETUP/fish.sh


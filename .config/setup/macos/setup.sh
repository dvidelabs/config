#!/bin/bash

SETUP=$(dirname $0)/..

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi


[ "$(which brew)" ] || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "updating homebrew"
brew update
[ "$(which fish)" ] || brew install fish
[ "$(which tmux)" ] || brew install tmux
[ "$(which ag)archer)" ] || brew install the_silver_searcher # ag
# Even if an otherwise good enough vim is already installed, we need
# `vim --version` showing +clipboard, which homebrew provides.
vim --version 2>/dev/null | grep \+clipboard >/dev/null 2>&1 || brew install vim


$SETUP/vim.sh
$SETUP/zsh.sh
$SETUP/fish.sh


[ -d "/Applications/iTerm.app" ] || brew install --cask iterm2

# If fonts are provided, add them to the system.
if [ -d $HOME/.config/resources/macos/fonts ]; then
    mkdir -p $HOME/Library/Fonts
    cp -r $HOME/.config/resources/macos/fonts/* $HOME/Library/Fonts
fi

defaults write com.googlecode.iterm2 TimeBetweenBlinks -float 0.38

# Avoid creation of .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Ask for password screen lock delay
defaults -currentHost write com.apple.screensaver askForPasswordDelay -int 10

# set tw=58
echo "------------------------------------------------------------

NOTE: Suggested manual configuration:

  Add the following themes to iTerm2 if needed:

    $HOME/.config/resources/macos/iterm2

  Keyboard setup:

  Consider swapping Alt and Ctrl to get right hand
  Ctrl key and to map Cmd+Space to language input toggle
  between US and local keyboard. Map Caps Lock to Escape for Vim.

  Homebrew might require permission changes, but see discussion below:

      $ sudo chown -R $(whoami):admin $(brew --prefix)/*
    or
      $ sudo chown -R $(whoami):admin /usr/local/*

  https://gist.github.com/irazasyed/773294://gist.github.com/irazasyed/7732946

  This is because homebrew does not like to run as root, but this leaves
  the binary tree exposed to malicious updates. Other suggests to edit
  brew.sh and permit it to run as root. Another option might be to leave
  as is, and fix brew to allow 'brew link' as root via override in
  /usr/local/Homebrew/Library/Homebrew/brew.sh

  XCode command line tools may be required:

    $ sudo xcode-select --install

  To set the default shell to e.g. fish, use:

    $ chsh -s $(which fish)

------------------------------------------------------------

completed MacOS specific setup"

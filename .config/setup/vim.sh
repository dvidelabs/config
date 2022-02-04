#!/bin/sh
echo "setting up vim swap and backup dirs"
mkdir -p ~/.vim/tmp/backup
mkdir -p ~/.vim/tmp/swap

if [ ! -e $HOME/.vim/autoload/plug.vim ]; then
  echo "installing vim plugin manager ..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -u $HOME/.vimrc.plug +PlugInstall +qall
else
  echo "vim plugin manager already installed, skipping ..."
fi

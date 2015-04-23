#!/usr/bin/env bash
DIR=~/.bash
RCFILES=$DIR/rcfiles
bash "`dirname $0`/git-setup.sh"

echo "Setting up symlinks"

if [ ! -L ~/.vimrc ]; then
  ln -s $DIR/vimrc ~/.vimrc
fi

if [ ! -L ~/.nvimrc ]; then
  ln -s $DIR/vimrc ~/.nvimrc
fi

if [ ! -L ~/.nvim ]; then
  ln -s ~/.vim ~/.nvim
fi

if [ ! -L ~/.inputrc ]; then 
  ln -s $RCFILES/inputrc ~/.inputrc
fi

if [ ! -L ~/.xbindkeysrc ]; then
  ln -s $RCFILES/xbindkeysrc ~/.xbindkeysrc
fi

if [ ! -L ~/.sqliterc ]; then 
  ln -s $RCFILES/sqliterc ~/.sqliterc
fi

if [ ! -L ~/.jshintrc ]; then 
  ln -s $RCFILES/jshintrc ~/.jshintrc
fi

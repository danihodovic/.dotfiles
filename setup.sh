#!/usr/bin/env bash
DIR="`dirname $0`"
DIR=~/.bash
if [ ! -L ~/.vimrc ]; then
  ln -s $DIR/vimrc ~/.vimrc
fi

if [ ! -L ~/.nvimrc ]; then
  ln -s $DIR/vimrc ~/.nvimrc
fi

if [ ! -L ~/.inputrc ]; then 
  ln -s $DIR/inputrc ~/.inputrc
fi

if [ ! -L ~/.xbindkeysrc ]; then
  ln -s $DIR/specific-rcfiles/xbindkeysrc ~/.xbindkeysrc
fi

if [ ! -L ~/.sqliterc ]; then 
  ln -s $DIR/specific-rcfiles/sqliterc ~/.sqliterc
fi

if [ ! -L ~/.jshintrc ]; then 
  ln -s $DIR/specific-rcfiles/jshintrc ~/.jshintrc
fi

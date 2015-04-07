#!/usr/bin/env bash
DIR=~/.vim/bundle/Vundle.vim
if [ ! -d "$DIR" ]; then
    mkdir ~/.vim
    mkdir ~/.vim/bundle
    git clone https://github.com/gmarik/Vundle ~/.vim/bundle/Vundle.vim
else
    echo "Vundle is already installed"
fi

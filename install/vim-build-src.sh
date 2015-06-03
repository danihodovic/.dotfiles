#!/usr/bin/env bash
# Note: Outdated, don't use. Why? 
# - checkinstall is incompatible with apt sometimes
# - neovim is a better option than vim
# - vim-plugged is a better option than Vundle
#
# Taken from from:
# https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
#
# Uninstall using:
# apt-get remove <tempdir-name>
#
TEMP=vim

sudo apt-get remove vim vim-runtime gvim vim-tiny vim-common vim-gui-common -y

# Dependencies
sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev \
    libx11-dev libxpm-dev libxt-dev python-dev ruby-dev mercurial -y

sudo apt-get install checkinstall -y


hg clone https://vim.googlecode.com/hg/ $TEMP
cd $TEMP
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr

make VIMRUNTIMEDIR=/usr/share/vim/vim74
sudo checkinstall -y
cd ..

sudo rm -rf $TEMP

git clone https://github.com/gmarik/Vundle ~/.vim/bundle/Vundle.vim
vim +BundleInstall +qa
cd ~/.vim/bundle/YouCompleteMe
sh install.sh

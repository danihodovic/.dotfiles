#!/usr/bin/env bash

read -p "Install zsh+oh-my-zsh+tmux?"           INSTALL_ZSH
read -p "Install Neovim ppa + neovim pip?"      INSTALL_NEOVIM

set -e

case $INSTALL_ZSH in
    y|Y)
        echo "Installing zsh and oh-my-zsh"
        sudo apt-get install zsh -y
        git clone git@github.com:robbyrussell/oh-my-zsh ~/.oh-my-zsh
        echo "Installing tmux and tpm"
        sudo apt-get install tmux
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ;;
esac

case $INSTALL_NEOVIM in
    y|Y)
        # Check so that the env var is set. This probably means our dotfiles are
        # installed. -z checks that the length of the env var is > 0
        if [ -z "$NVIM_DIR" ]; then
            echo "Setup your dotfiles and source zshrc before attempting to install.."
            exit 1
        fi

        if [ ! -d "$NVIM_DIR" ]; then
            echo "...Setting up nvim directories and symlinks..."
            mkdir -p ~/.config/nvim
            # We can assume dotfiles are set because of $NVIM_DIR being set
            ln -s ~/.dotfiles/vimrc ~/.config/init.vim
        fi

        # Neovim from pip needs to be installed for the python plugins to work
        hash pip 2>/dev/null
        if [ $? -eq 1 ]; then
            sudo wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        fi

        hash nvim 2>/dev/null
        if [ $? -eq 1 ]; then
            echo "...Installing neovim..."
            sudo apt-add-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update
            sudo apt-get install neovim -y
            sudo pip install neovim
        else
            echo "...Neovim already installed..."
        fi

        # neovim stores backup files here but that directory isn't created by default
        #mkdir ~/.local/share/nvim/backup
        #ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim
        if [ ! -f "$NVIM_DIR/autoload/plug.vim" ]; then
            echo "...Installing vim-plug..."
            PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs $PLUG_URL
        else
            echo "...vim-plug already installed..."
        fi

        ;;
esac


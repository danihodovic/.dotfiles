#!/usr/bin/env bash
set -e

# -p <output this string before reading>
# -n <number return input after *this* many characters instead of waiting for newline>
# -r do not allow backslashes to escape any characters
# Add an optional param last where output is stored
read -p "Install zsh (+antigen) and tmux (+tpm)? " -n 1 -r  install_zsh
echo
read -p "Install Neovim ppa + neovim pip? " -n 1 -r         install_neovim
echo

# Todo: Add antigen
case $install_zsh in
    y|Y)
        if [ -z "$ANTIGEN_PATH" ]; then
            echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
            exit 1
        fi

        echo "Installing zsh"
        sudo apt-get install zsh -y

        echo "Installing tmux and tpm"
        sudo apt-get install tmux
        if [ ! -d ~/.tmux/plugins/tpm ]; then
            echo "Installing tpm"
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        fi

        if [ ! -f "$ANTIGEN_PATH" ]; then
            echo "Installing antigen"
            ANTIGEN_URL=https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh
            curl -fLo $ANTIGEN_PATH --create-dirs $ANTIGEN_URL
        fi
esac

case $install_neovim in
    y|Y)

        # Check so that the env var is set. This probably means our dotfiles are
        # installed. -z checks that the length of the env var is > 0
        if [ -z "$NVIM_DIR" ]; then
            echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
            exit 1
        fi

        if [ ! -d "$NVIM_DIR" ]; then
            echo "...Setting up nvim directories and symlinks..."
            mkdir -p ~/.config/nvim
            # We can assume .dotfiles exist because of $NVIM_DIR being set
            ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim
        else
	        echo "Neovim config files already set up"
        fi

        if [ ! -f "$NVIM_DIR/autoload/plug.vim" ]; then
            echo "...Installing vim-plug..."
            PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs $PLUG_URL
        else
            echo "...vim-plug already installed..."
        fi

        # Neovim from pip needs to be installed for the python plugins to work
        hash pip || true
        if [ $? -eq 1 ]; then
            sudo wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        else
	    echo "Pip already installed"
        fi

        hash nvim || true
        if [ $? -eq 1 ]; then
            echo "...Installing neovim..."
            sudo apt-add-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update
            sudo apt-get install neovim -y
            sudo pip install neovim
        else
            echo "...Neovim already installed..."
        fi

        ;;
esac


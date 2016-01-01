#!/usr/bin/env bash
set -e
set -u

# -p <output this string before reading>
# -n <number return input after *this* many characters instead of waiting for newline>
# -r do not allow backslashes to escape any characters
# Add an optional param last where output is stored

read -p "Install gnome terminal from the latest ppa? " -n 1 -r  install_gnome_terminal
echo
read -p "Install zsh and tmux? " -n 1 -r  install_zsh
echo
read -p "Install Neovim ppa + neovim pip? " -n 1 -r         install_neovim
echo
read -p "Install zsh plugin manager antigen? " -n 1 -r  install_antigen
echo
read -p "Install nvim plugin manager vim-plug? " -n 1 -r  install_vim_plug
echo
read -p "Install tmux plugin manager tpm? " -n 1 -r  install_tpm
echo
read -p "Setup nvim?" -n 1 -r  setup_nvim
echo
read -p "Install patched Hack font (Knack)?" -n 1 -r install_knack_patched
echo


case $install_gnome_terminal in
  y)
    sudo add-apt-repository ppa:gnome3-team/gnome3-staging
    sudo apt-get update
    sudo apt-get install gnome-terminal
    ;;
esac

# Todo: Add antigen
case $install_zsh in
    y|Y)
        if [ -z "$ANTIGEN_PATH" ]; then
            echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
            exit 1
        fi

        echo "Installing zsh"
        sudo apt-get install -y zsh

        echo "Installing tmux"
        sudo apt-get install -y tmux


esac


case $install_neovim in
    y|Y)

        # Neovim from pip needs to be installed for the python plugins to work
        set +e
        hash pip
        pip_installed=$?
        set -e

        if [ $pip_installed -eq 1 ]; then
            sudo wget -O - https://bootstrap.pypa.io/get-pip.py | sudo python
        elif [ $pip_installed -eq 0 ]; then
            echo "Pip already installed"
        fi

        set +e
        hash nvim
        nvim_installed=$?
        set -e

        if [ $nvim_installed -eq 1 ]; then
            echo "...Installing neovim..."
            sudo apt-add-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update
            sudo apt-get install neovim -y
            sudo pip install neovim
        elif [ $nvim_installed -eq 0 ]; then
            echo "...Neovim already installed..."
        fi

        ;;
esac


case $install_antigen in
  y)
      if [ -z "$ANTIGEN_PATH" ]; then
          echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
          exit 1
      fi

      if [ ! -f "$ANTIGEN_PATH" ]; then
          echo "Installing antigen"
          ANTIGEN_URL=https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh
          curl -fLo $ANTIGEN_PATH --create-dirs $ANTIGEN_URL
      fi
esac


case $install_vim_plug in
  y)
      # Check so that the env var is set. This probably means our dotfiles are
      # installed. -z checks that the length of the env var is > 0
      # Todo check if this dir is not a symlink
      if [ -z "$NVIM_DIR" ]; then
          echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
          exit 1
      fi

      if [ ! -d "$NVIM_DIR" ]; then
          echo "...Creating ~/.config/nvim..."
          mkdir -p ~/.config/nvim
      else
        echo "Neovim config files already set up"
      fi

      if [ ! -f "$NVIM_DIR/autoload/plug.vim" ]; then
          echo "...Installing vim-plug..."
          PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
          curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs $PLUG_URL
      else
          echo "vim-plug already installed..."
      fi
esac


case $install_tpm in
  y)
      if [ ! -d ~/.tmux/plugins/tpm ]; then
          echo "Installing tpm"
          git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      else
         echo "Tpm already installed"
      fi
esac


case $setup_nvim in
  y)
      if [ -z "$NVIM_DIR" ]; then
          echo "[Error] Setup your dotfiles and source zshrc before attempting to install.."
          exit 1
      fi

      if [ ! -d "$NVIM_DIR" ]; then
          mkdir -p ~/.config/nvim
      fi

      if [ ! -L "${NVIM_DIR}/init.vim" ]; then
          echo "Setting up nvim config..."
          ln -s ~/.dotfiles/vimrc ~/.config/nvim/init.vim
      else
          echo "Neovim config files already set up"
      fi

esac

case $install_knack_patched in
  y)
      fontfile="${HOME}/.fonts/Knack Regular Nerd Font Complete Mono.ttf"
      url="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Knack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"

      if [ ! -f "$fontfile" ]; then
        [ ! -d ${HOME}/.fonts ] && mkdir ${HOME}/.fonts
        curl -f -L -o "$fontfile" $url
        fc-cache -fv
      fi
esac

#!/usr/bin/env python3

import os
import sys
import urllib.request
import shutil
import getpass
import tarfile
import io
import json
import tempfile
import subprocess

def install_neovim():
    cmd = '''
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y neovim python-pip
    pip install --upgrade neovim
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_docker():
    user = getpass.getuser()

    cmd = f'''
    sudo apt-get update
    sudo apt-get install -y curl

    curl https://get.docker.com | sudo bash

    sudo apt-get install -y python-pip
    sudo pip install docker-compose

    sudo usermod -a -G docker {user}
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_vim_plug():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_antibody():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    curl -sL https://git.io/antibody | sudo bash -s
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_fzf():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y git

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_hub():
    releases_url = 'https://api.github.com/repos/github/hub/releases'
    latest_release_res = urllib.request.urlopen(releases_url)
    body = json.load(latest_release_res)
    latest_release_assets = body[0]['assets']

    tarfile_url = ''
    for asset in latest_release_assets:
        if 'Linux 64-bit' in asset['label']:
            tarfile_url = asset['browser_download_url']
            break

    cmd = f'''
    sudo apt-get update
    sudo apt-get install -y curl git

    cd $(mktemp -d)
    curl -L {tarfile_url} -o - | tar -xz
    cd hub*
    sudo ./install
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_gvm():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y git curl binutils bison gcc

    url=https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer
    curl -s -S -L $url | bash
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_n():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    # https://github.com/mklement0/n-install#examples
    curl -L https://git.io/n-install | N_PREFIX=$HOME/.n bash -s -- -y lts
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_chrome():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    url=https://dl-ssl.google.com/linux/linux_signing_key.pub
    curl --silent $url | sudo apt-key add
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | \
        sudo tee /etc/apt/sources.list.d/google-chrome.list

    sudo apt-get update
    sudo apt-get install -y google-chrome-stable
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_i3_completions():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    url=https://raw.githubusercontent.com/cornerman/i3-completion/master/i3_completion.sh
    curl $url -o ~/.i3_completion.sh
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_diff_so_fancy():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl perl-modules-5.26

    url=https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
    sudo curl $url -o /usr/local/bin/diff-so-fancy
    sudo chmod +x /usr/local/bin/diff-so-fancy
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_tldr():
    cmd = '''
    sudo apt-get update
    sudo apt-get install -y curl

    url=https://raw.githubusercontent.com/raylee/tldr/master/tldr
    sudo curl $url -o /usr/local/bin/tldr
    sudo chmod +x /usr/local/bin/tldr
    '''
    subprocess.run(cmd, shell=True, check=True)

def install_alacritty():
    cmd = '''
    set -e
    export PATH=$PATH:${HOME}/.cargo/bin

    sudo apt-get update
    sudo apt-get install -y curl git cmake libfreetype6-dev libfontconfig1-dev xclip
    curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
    if [ ! -d ~/repos/alacritty ]; then
      mkdir -p ~/repos
      git clone https://github.com/jwilm/alacritty.git ~/repos/alacritty
    else
      cd ~/repos/alacritty
      git pull
    fi
    cd ~/repos/alacritty
    rustup override set stable
    rustup update stable
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin/
    '''
    subprocess.run(cmd, shell=True, check=True)

def _assert_python_version():
    version = float(sys.version[0:3])
    min_version = 3.4
    if version < min_version:
        print('Error: Python version {} detected, use at least version {}', version, min_version)
        sys.exit(1)


###############################
# Main
###############################
if __name__ == '__main__':
    _assert_python_version()

    install_options = [
        ('Install docker? [y/n] ', install_docker),
        ('Install neovim? [y/n] ', install_neovim),
        ('Install vim-plug? [y/n] ', install_vim_plug),
        ('Install fzf? [y/n] ', install_fzf),
        ('Install antibody? [y/n] ', install_antibody),
        ('Install hub? [y/n] ', install_hub),
        ('Install gvm? [y/n] ', install_gvm),
        ('Install n? [y/n] ', install_n),
        ('Install google chrome? [y/n] ', install_chrome),
        ('Install diff-so-fancy? [y/n] ', install_diff_so_fancy),
        ('Install tldr? [y/n] ', install_tldr),
    ]

    to_install = []

    if input('Install all? ') == 'y':
        for _, fn in install_options:
            to_install.append(fn)
    else:
        for phrase, fn in install_options:
            response = input(phrase)
            if response == 'y':
                to_install.append(fn)

    for fn in to_install: fn()


#!/usr/bin/env python3.5

# TODO: Add `pip install neovim`

import subprocess
import os
import urllib.request
import shutil

def install_zsh():
    executable = 'zsh'
    cmd = 'sudo apt-get install zsh'
    install_cmd(executable, cmd)


def install_tmux():
    executable = 'tmux'
    cmd = 'sudo apt-get install tmux'
    install_cmd(executable, cmd)


def install_nvim():
    executable = 'nvim'
    cmd = '''
        sudo apt-add-repository ppa:neovim-ppa/unstable -y;
        sudo apt-get update;
        sudo apt-get install neovim -y
    '''
    install_cmd(executable, cmd)


def install_pip3():
    executable = 'pip3'
    cmd = 'sudo apt-get install python3-pip'
    install_cmd(executable, cmd)


def update_alternatives_python3():
    cmdpy2 = 'sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1'
    cmdpy3 = 'sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1'
    cmdUpdateAlt = 'sudo update-alternatives --set python /usr/bin/python3.5'

    proc = popen('{} && {} && {}'.format(cmdpy2, cmdpy3, cmdUpdateAlt))

    if proc.wait() != 0:
        (_, stderr) = proc.communicate()
        raise subprocess.SubprocessError(stderr.decode('utf8'))


def install_antigen():
    antigen_file = os.path.expandvars('${HOME}/.antigen/antigen.zsh')
    url = 'https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh'
    download_to_file(url, antigen_file)


def install_vim_plug():
    plug_file = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')
    url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    download_to_file(url, plug_file)


def install_tpm():
    tpm_file = os.path.expandvars('${HOME}/.tmux/plugins/tpm')
    url = "https://github.com/tmux-plugins/tpm"
    if not os.path.isdir(tpm_file):
        os.makedirs(os.path.dirname(tpm_file), exist_ok=True)
    proc = popen('git clone {} {}'.format(url, tpm_file))
    (_, stderr) = proc.communicate()
    if proc.wait() != 0:
        raise subprocess.SubprocessError(stderr.decode('utf8'))


def install_knack_font():
    knack_file = '${HOME}/.fonts/Knack Regular Nerd Font Complete Mono.ttf'
    url = 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts' \
        '/Hack/Regular/complete/Knack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf'
    download_to_file(url, knack_file)
    proc = popen('fc-cache -f')
    if proc.wait() != 0:
        (_, stderr) = proc.communicate()
        raise subprocess.SubprocessError(stderr.decode('utf8'))


def popen(cmd):
    return subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def install_cmd(executable, cmd):
    exists = popen('hash ' + executable).wait()

    if exists == 0:
        print('{} is already installed'.format(executable))
    else:
        proc = popen(cmd)
        (_, stderr) = proc.communicate()
        if proc.wait() != 0:
            raise subprocess.SubprocessError(stderr.decode('utf8'))


def download_to_file(url, thefile):
    parent_dir = os.path.dirname(thefile)
    if not os.path.isdir(parent_dir):
        os.makedirs(parent_dir, exist_ok=True)

    if not os.path.isfile(thefile):
        with urllib.request.urlopen(url) as res:
            with open(thefile, 'wb') as f:
                shutil.copyfileobj(res, f)


if __name__ == '__main__':
    ins_zsh      = input('Install zsh? [y/n]')
    ins_tmux     = input('Install tmux? [y/n]')
    ins_neovim   = input('Install neovim? [y/n]')
    ins_antigen  = input('Install antigen? [y/n]')
    ins_vim_plug = input('Install vim-plug? [y/n]')
    ins_tpm      = input('Install tpm? [y/n]')
    ins_knack    = input('Install knack font? [y/n]')
    choose_py    = input('Set py3 as default? [y/n]')

    if ins_zsh == 'y':
        install_zsh()

    if ins_tmux == 'y':
        install_tmux()

    if ins_neovim == 'y':
        install_pip3()
        install_nvim()

    if ins_antigen == 'y':
        install_antigen()

    if ins_vim_plug== 'y':
        install_vim_plug()

    if ins_tpm == 'y':
        install_tpm()

    if ins_knack == 'y':
        install_knack_font()

    if choose_py == 'y':
        update_alternatives_python3()

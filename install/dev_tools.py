#!/usr/bin/env python3

import os
import sys
import urllib
import shutil
import getpass
import apt
import apt.progress
import lsb_release

user = getpass.getuser()

###############################
# Apt packages
###############################
def install_neovim():
    print('Adding neovim ppa...')
    lsb_codename = lsb_release.get_lsb_information()['CODENAME']
    filename = '/etc/apt/sources.list.d/neovim-ppa.list'
    line = 'deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu {0} main\n'.format(lsb_codename)
    print('Using ppa: {}'.format(line))
    f = open(filename, 'w')
    os.chmod(filename, 0o644)
    f.write(line)
    f.close()

    cache = apt.cache.Cache()
    cache.update()
    cache.commit()

    pkg_name = 'neovim'
    install_apt_pkg(pkg_name)

    print('''Please install neovim via pip.
    We can't automate this in a simple way since it depends on the default python version''')
    #  install_apt_pkg('python-pip')
    #  import pip
    #  pip.main(['install', 'neovim'])
    #  pip.main(['install', '--upgrade', 'pip'])

def install_zsh():
    pkg_name = 'zsh'
    install_apt_pkg(pkg_name)


def install_tmux():
    pkg_name = 'tmux'
    install_apt_pkg(pkg_name)

###############################
# Plugin managers
###############################
def install_vim_plug():
    plug_file = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')
    url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    download_to_file(url, plug_file)


def install_apt_pkg(pkg_name):
    print('Installing {}...'.format(pkg_name))
    cache = apt.cache.Cache()
    cache.update()
    cache.commit()

    pkg = cache[pkg_name]

    if pkg.is_installed:
        print("Package: {pkg_name} is already installed".format(pkg_name=pkg_name))
    else:
        pkg.mark_install()
        cache.commit()


def download_to_file(url, thefile):
    parent_dir = os.path.dirname(thefile)
    if not os.path.isdir(parent_dir):
        os.makedirs(parent_dir)
        shutil.chown(parent_dir, user=user, group=user)

    if not os.path.isfile(thefile):
        with urllib.request.urlopen(url) as res:
            with open(thefile, 'wb') as f:
                shutil.copyfileobj(res, f)
                shutil.chown(thefile, user=user, group=user)


###############################
# Main
###############################
if __name__ == '__main__':

    if os.geteuid() != 0:
        print('Error: Run the script as root as we need to use apt')
        sys.exit(1)

    version = float(sys.version[0:3])
    min_version = 3.4
    if version < min_version:
        print('Error: Python version {} detected, use at least version {}', version, min_version)
        sys.exit(1)

    ins_neovim   = input('Install neovim? [y/n]')
    ins_zsh      = input('Install zsh? [y/n]')
    ins_tmux     = input('Install tmux? [y/n]')
    ins_vim_plug = input('Install vim-plug? [y/n]')

    if ins_neovim == 'y':
        install_neovim()

    if ins_zsh == 'y':
        install_zsh()

    if ins_tmux == 'y':
        install_tmux()

    if ins_vim_plug== 'y':
        install_vim_plug()


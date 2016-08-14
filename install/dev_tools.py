#!/usr/bin/env python3

import os
import sys
import urllib
import shutil
import getpass
import tarfile
import platform
import contextlib
import apt
import apt.progress
import lsb_release

user = getpass.getuser()

@contextlib.contextmanager
def cache_handler():
    cache = None
    try:
        cache = apt.cache.Cache()
        cache.open()
        yield cache
    finally:
        cache.close()

###############################
# Apt packages
###############################
def install_neovim():
    with cache_handler() as cache:
        pkg_name = 'neovim'

        if pkg_name in cache and cache[pkg_name].is_installed:
            print('Package: neovim already installed')
            return

        print('Adding neovim ppa...')
        lsb_codename = lsb_release.get_lsb_information()['CODENAME']
        filename = '/etc/apt/sources.list.d/neovim-ppa.list'
        line = 'deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu {0} main\n'.format(lsb_codename)
        print('Using ppa: {}'.format(line))

        with open(filename, 'w') as f:
            os.chmod(filename, 0o644)
            f.write(line)

        # apt-get update after adding the ppa
        cache.open()
        cache.update(raise_on_error=True)
        cache.open()

        install_apt_pkg(cache, pkg_name)

        # Install neovim for python to (for python plugins)
        install_apt_pkg(cache, 'python3-pip')
        import pip
        pip.main(['install', 'neovim'])

def install_zsh():
    with cache_handler() as cache:
        pkg_name = 'zsh'
        install_apt_pkg(cache, pkg_name)

def install_tmux():
    with cache_handler() as cache:
        pkg_name = 'tmux'
        install_apt_pkg(cache, pkg_name)

###############################
# Plugin managers
###############################
def install_vim_plug():
    plug_file = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')
    url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    download_to_file(url, plug_file)

def install_antibody():
    base_url = 'https://github.com/getantibody/antibody/releases/download'
    url = '{base_url}/v0.9.2/antibody_{system}_{machine}.tar.gz'.format(
        base_url=base_url, system=platform.system(), machine=platform.machine())
    filename = '/tmp/antibody.tar.gz'
    download_to_file(url, filename)
    with tarfile.open(filename, 'r:gz') as tar:
        tar.extract('./antibody', '/usr/local/bin/')

def install_apt_pkg(cache, pkg_name):
    cache.open()
    if not cache.has_key(pkg_name):
        raise Exception('Error - Package: {} could not be found in the cache'.format(pkg_name))
    elif cache.has_key(pkg_name) and not cache[pkg_name].is_installed:
        print('Installing {}...'.format(pkg_name))
        pkg = cache[pkg_name]
        pkg.mark_install()
        cache.commit()
    elif cache[pkg_name].is_installed:
        print("Package: {pkg_name} is already installed".format(pkg_name=pkg_name))


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


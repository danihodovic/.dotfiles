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
import io
import json
import tempfile
import subprocess

user = getpass.getuser()

@contextlib.contextmanager
def cache_handler():
    cache = None
    try:
        cache = apt.cache.Cache()
        cache.open()
        yield cache
    finally:
        if cache:
            cache.close()

def install_neovim():
    apt_get_install('software-properties-common')
    add_apt_repository('ppa:neovim-ppa/unstable')
    apt_get_update()
    apt_get_install('neovim')

    # Install neovim for python (for python plugins)
    apt_get_install('python-pip')
    proc = subprocess.Popen(['pip', 'install', '--upgrade', 'neovim'])
    proc.wait()

def install_docker():
    download_to_file('https://get.docker.com', '/tmp/get-docker.sh')
    proc = subprocess.Popen(['sh', '/tmp/get-docker.sh'])
    proc.wait()

    install_docker_compose()

def install_vim_plug():
    plug_file = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')
    url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    download_to_file(url, plug_file)

def install_antibody():
    latest_release_url = 'https://api.github.com/repos/getantibody/antibody/releases/latest'
    latest_release_res = urllib.request.urlopen(latest_release_url)
    body = json.load(latest_release_res)
    linux_tarball_url = body['assets'][10]['browser_download_url']

    tar_res = urllib.request.urlopen(linux_tarball_url)
    file_like_object = io.BytesIO(tar_res.read())
    tar = tarfile.open(fileobj=file_like_object)
    tempdir = tempfile.mkdtemp(prefix='antibody-')
    tar.extractall(path=tempdir)
    shutil.copy(tempdir + '/antibody', '/usr/local/bin/antibody')

def install_fzf():
    apt_get_install('git')
    apt_get_install('curl')
    home = os.path.expanduser('~')
    subprocess.check_output([
        'git', 'clone',
        '--depth', '1',
        'https://github.com/junegunn/fzf.git', home + '/.fzf'
    ])
    script =  home + '/.fzf/install'
    proc = subprocess.Popen([script, '--key-bindings', '--completion', '--no-update-rc'])
    proc.wait()


def apt_get_install(pkg_name):
    env = os.environ.copy()
    env['DEBIAN_FRONTEND'] = 'noninteractive'
    cmd = ['apt-get', 'install', '-y', pkg_name]
    proc = subprocess.Popen(cmd, env=env)
    proc.wait()

def apt_get_update():
    cmd = ['apt-get', 'update']
    proc = subprocess.Popen(cmd)
    proc.wait()

def add_apt_repository(repository):
    cmd = ['add-apt-repository', '-y', repository]
    proc = subprocess.Popen(cmd)
    proc.wait()

def download_to_file(url, path):
    parent_dir = os.path.dirname(path)
    if not os.path.isdir(parent_dir):
        os.makedirs(parent_dir)
        shutil.chown(parent_dir, user=user, group=user)

    if not os.path.isfile(path):
        with urllib.request.urlopen(url) as res:
            with open(path, 'wb') as f:
                shutil.copyfileobj(res, f)
                shutil.chown(path, user=user, group=user)


def install_docker_compose():
    url = 'https://github.com/docker/compose/releases/download/1.18.0/run.sh'
    path = '/usr/local/bin/docker-compose'
    download_to_file(url, path)
    subprocess.check_output(['chmod', '755', path])

install = [
    ('Install neovim? [y/n]', install_neovim),
    ('Install vim-plug? [y/n]', install_vim_plug),
    ('Install antibody? [y/n]', install_antibody),
    ('Install fzf? [y/n]', install_fzf)
]

def _assert_sudo():
    if os.geteuid() != 0:
        print('Error: Run the script as root as we need to use apt')
        sys.exit(1)

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
    _assert_sudo()

    if input('Install all?') == 'y':
        for _, install_func in install:
            install_func()

    for phrase, install_func in install:
        response = input(phrase)
        if response == 'y':
            install_func()


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

###############################
# Apt packages
###############################
def install_neovim():
    pkg_name = 'neovim'

    print('Adding neovim ppa...')
    lsb_codename = lsb_release.get_lsb_information()['CODENAME']
    filename = '/etc/apt/sources.list.d/neovim-ppa.list'
    line = 'deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu {0} main\n'.format(lsb_codename)
    print('Using ppa: {}'.format(line))

    with open(filename, 'w') as f:
        os.chmod(filename, 0o644)
        f.write(line)

    # apt-get update after adding the ppa
    apt_get_update()

    apt_get_install(pkg_name)

    # Install neovim for python (for python plugins)
    apt_get_install('python-pip')
    subprocess.check_output(['pip', 'install', 'neovim'])

def install_zsh():
    pkg_name = 'zsh'
    apt_get_install(pkg_name)

def install_tmux():
    pkg_name = 'tmux'
    apt_get_install(pkg_name)

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


def install_fzf():
    url = 'https://api.github.com/repos/junegunn/fzf/tags'
    with urllib.request.urlopen(url) as res:
        content = res.read().decode('utf8')
        as_json = json.loads(content)
        tarball_url = as_json[0]['tarball_url']

        with urllib.request.urlopen(tarball_url) as res:
            file_like_object = io.BytesIO(res.read())
            tar = tarfile.open(fileobj=file_like_object)
            tarname = tar.members[0].name
            tempdir = tempfile.mkdtemp()
            tar.extractall(path=tempdir)
            os.rename(tempdir + '/' + tarname, os.path.expandvars('${HOME}/.fzf'))

    # Run the shell installation script which sets up fzf specific dotfiles
    apt_get_install('curl')
    script = os.path.expanduser('~') + '/.fzf/install'
    proc = subprocess.Popen([script, '--key-bindings', '--completion', '--no-update-rc'])
    proc.wait()


def apt_get_install(pkg_name):
    cmd = ['apt-get', 'install', '-y', '--allow-unauthenticated', pkg_name]
    proc = subprocess.Popen(cmd)
    proc.communicate()

def apt_get_update():
    cmd = ['apt-get', 'update']
    proc = subprocess.Popen(cmd)
    proc.communicate()

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

def install_docker():
    apt_get_update()

    # Install dependencies
    apt_get_install('ca-certificates')
    apt_get_install('apt-transport-https')

    # Add the keyserver
    subprocess.check_output([
        'apt-key', 'adv',
        '--keyserver', 'hkp://p80.pool.sks-keyservers.net:80',
        '--recv-keys', '58118E89F3A912897C070ADBF76221572C52609D',
    ])

    #  Add the ppa
    ubuntu_codename = lsb_release.get_lsb_information()['CODENAME']
    line = 'deb https://apt.dockerproject.org/repo ubuntu-{} main'.format(ubuntu_codename)
    filename = '/etc/apt/sources.list.d/docker.list'
    print('Using ppa: {}'.format(line))

    with open(filename, 'w') as f:
        os.chmod(filename, 0o644)
        f.write(line)

    apt_get_update()

    # Install linux-image-extra-virtual for the aufs filesystem
    kernel_version = subprocess.check_output(['uname', '-r']).decode('utf8').rstrip()
    linux_image_headers = 'linux-image-extra-{}'.format(kernel_version)
    apt_get_install(linux_image_headers)
    apt_get_install('linux-image-extra-virtual')

    # Finally install docker
    apt_get_install('docker-engine')

    # Add me to the docker user
    try:
        output = subprocess.check_output(['groupadd', 'docker'], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        group_exists_msg = "groupadd: group 'docker' already exists"
        if not e.output.decode('utf8').startswith(group_exists_msg):
            raise e

    # TODO: Hack because test fails in docker because no dani user exists
    try:
        subprocess.check_output(['usermod', '-a', '-G', 'docker', 'dani'])
    except subprocess.CalledProcessError as e:
        pass

    try:
        subprocess.check_output(['su', '-', 'dani'])
    except subprocess.CalledProcessError as e:
        pass

    install_docker_compose()

def install_docker_compose():
    url = 'https://github.com/docker/compose/releases/download/1.8.1/run.sh'
    path = '/usr/local/bin/docker-compose'
    download_to_file(url, path)
    subprocess.check_output(['chmod', '755', path])

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
    ins_antibody = input('Install antibody? [y/n]')
    ins_fzf      = input('Install fzf? [y/n]')

    if ins_neovim == 'y':
        install_neovim()

    if ins_zsh == 'y':
        install_zsh()

    if ins_tmux == 'y':
        install_tmux()

    if ins_vim_plug == 'y':
        install_vim_plug()

    if ins_antibody == 'y':
        install_antibody()

    if ins_fzf == 'y':
        install_fzf()

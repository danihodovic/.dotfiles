#!/usr/bin/env python3.5

import sys
import os
import pwd
import grp
import unittest
import getpass
import shutil
import re

repo_root = os.path.expanduser('~/.dotfiles/install')
sys.path.append(repo_root)
import dev_tools

HOME = os.path.expanduser('~')

user = getpass.getuser()
vim_plug_path = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')
antibody_path = os.path.expandvars('/usr/local/bin/antibody')

min_version = 3.4
version = float(sys.version[0:3])
if version < min_version:
    print('Error: Python version {} detected, use at least version {}', version, min_version)
    sys.exit(1)

class IntegrationSuite(unittest.TestCase):
    ###############################
    # Apt packages
    ###############################

    def test_install_zsh(self):
        with dev_tools.cache_handler() as cache:
            remove_if_installed(cache, 'zsh')
            dev_tools.install_zsh()
            cache.open()
            self.assertTrue(is_installed_pkg(cache, 'zsh'))

    def test_install_tmux(self):
        with dev_tools.cache_handler() as cache:
            remove_if_installed(cache, 'tmux')
            dev_tools.install_tmux()
            cache.open()
            self.assertTrue(is_installed_pkg(cache, 'tmux'))

    def test_install_neovim(self):
        with dev_tools.cache_handler() as cache:
            remove_if_installed(cache, 'neovim')
            dev_tools.install_neovim()
            cache.open()
            self.assertTrue(is_installed_pkg(cache, 'neovim'))

    ###############################
    # Other
    ###############################

    def test_install_fzf(self):
        fzf_dir = HOME + '/.fzf'
        if os.path.isdir(fzf_dir):
            shutil.rmtree(fzf_dir)

        # We can't simply use HOME + '.fzf' + os.environ['SHELL'] because this variable
        #  doesn't exist in tests. So we have to look for both .bash and .zsh
        completion_file_regex = re.compile('fzf\.(bash|zsh)')
        for f in os.listdir(HOME):
            if completion_file_regex.search(f):
                os.remove(HOME + '/' + f)

        dev_tools.install_fzf()

        completion_file = None
        for f in os.listdir(HOME):
            if completion_file_regex.search(f):
                completion_file = f

        self.assertTrue(os.path.isfile(fzf_dir + '/bin/fzf-tmux'))
        self.assertTrue(completion_file != None)

    def test_install_vim_plug(self):
        if os.path.isfile(vim_plug_path):
            os.remove(vim_plug_path)

        dev_tools.install_vim_plug()
        self.assertTrue(os.path.isfile(vim_plug_path))

        file_user = find_owner(vim_plug_path)
        file_group = find_group(vim_plug_path)
        self.assertEqual(file_user, user)
        self.assertEqual(file_group, user)

    def test_install_antibody(self):
        if os.path.isfile(antibody_path):
            os.remove(antibody_path)

        dev_tools.install_antibody()
        self.assertTrue(os.path.isfile(antibody_path))

def is_installed_pkg(cache, pkg_name):
    return cache.has_key(pkg_name) and cache[pkg_name].is_installed

def remove_if_installed(cache, pkg_name):
    if is_installed_pkg(cache, pkg_name):
        cache[pkg_name].mark_delete(purge=True)
        cache.commit()

def find_owner(filename):
    return pwd.getpwuid(os.stat(filename).st_uid).pw_name

def find_group(filename):
    return grp.getgrgid(os.stat(filename).st_gid).gr_name

if __name__ == '__main__':
    unittest.main()


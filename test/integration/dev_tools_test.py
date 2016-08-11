#!/usr/bin/env python3.5

import sys
import os
import pwd
import grp
import unittest
import getpass
import apt

repo_root = os.path.expanduser('~/.dotfiles/install')
sys.path.append(repo_root)
import dev_tools

user = getpass.getuser()
vim_plug_path = os.path.expandvars('${HOME}/.config/nvim/autoload/plug.vim')

min_version = 3.4
version = float(sys.version[0:3])
if version < min_version:
    print('Error: Python version {} detected, use at least version {}', version, min_version)
    sys.exit(1)

class IntegrationSuite(unittest.TestCase):

    def setUp(self):
        # Remove apt packages to ensure they are installed
        cache = apt.cache.Cache()

        def remove_if_installed(pkg_name):
            if pkg_name in cache and cache[pkg_name].is_installed:
                cache[pkg_name].mark_delete(purge=True)

        remove_if_installed('zsh')
        remove_if_installed('tmux')
        remove_if_installed('neovim')

        cache.commit()

        # Remove files to ensure they are installed
        if os.path.isfile(vim_plug_path):
            os.remove(vim_plug_path)


    ###############################
    # Apt packages
    ###############################

    def test_install_zsh(self):
        dev_tools.install_zsh()
        self.assertTrue(is_installed_pkg('zsh'))

    def test_install_tmux(self):
        dev_tools.install_tmux()
        self.assertTrue(is_installed_pkg('tmux'))

    def test_install_neovim(self):
        dev_tools.install_neovim()
        self.assertTrue(is_installed_pkg('neovim'))

    ###############################
    # Other
    ###############################

    def test_install_vim_plug(self):
        dev_tools.install_vim_plug()
        self.assertTrue(os.path.isfile(vim_plug_path))

        file_user = find_owner(vim_plug_path)
        file_group = find_group(vim_plug_path)
        self.assertEqual(file_user, user)
        self.assertEqual(file_group, user)

def is_installed_pkg(pkg_name):
    cache = apt.cache.Cache()
    if pkg_name in cache:
        pkg = cache[pkg_name]
        return pkg.is_installed

def find_owner(filename):
    return pwd.getpwuid(os.stat(filename).st_uid).pw_name

def find_group(filename):
    return grp.getgrgid(os.stat(filename).st_gid).gr_name

if __name__ == '__main__':
    unittest.main()


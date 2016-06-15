#!/usr/bin/env python3.5

import sys
import os
import unittest
import apt
from unittest.mock import Mock, call, patch

repo_root = os.path.expanduser('~/.dotfiles/install')
sys.path.append(repo_root)

import dev_tools

min_version = 3.4
version = float(sys.version[0:3])
if version < min_version:
    print('Error: Python version {} detected, use at least version {}', version, min_version)
    sys.exit(1)

class IntegrationSuite(unittest.TestCase):

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

    def test_install_antigen(self):
        pass

def is_installed_pkg(pkg_name):
    cache = apt.cache.Cache()
    pkg = cache[pkg_name]
    return pkg.is_installed


if __name__ == '__main__':
    unittest.main()


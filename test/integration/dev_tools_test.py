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
        cache = apt.cache.Cache()
        pkg = cache['zsh']
        self.assertTrue(pkg.is_installed)

    def test_install_tmux(self):
        dev_tools.install_tmux()
        cache = apt.cache.Cache()
        pkg = cache['tmux']
        self.assertTrue(pkg.is_installed)

if __name__ == '__main__':
    unittest.main()


#!/usr/bin/env python3.5
import os
import unittest
from unittest.mock import patch
import setup

HOME_DIR = os.path.expandvars('${HOME}')
CONF_DIR = HOME_DIR + '/.dotfiles/conf'

conf_files = {
    CONF_DIR + '/inputrc':              HOME_DIR + '/.inputrc',
    CONF_DIR + '/tmux.conf':            HOME_DIR + '/.tmux.conf',
    CONF_DIR + '/sqliterc':             HOME_DIR + '/.sqliterc',
    CONF_DIR + '/jshintrc':             HOME_DIR + '/.jshintrc',
    CONF_DIR + '/pylintrc':             HOME_DIR + '/.pylintrc',
    CONF_DIR + '/pythonrc':             HOME_DIR + '/.pythonrc',
    CONF_DIR + '/jsbeautifyrc':         HOME_DIR + '/.jsbeautifyrc',
    CONF_DIR + '/tern-config':          HOME_DIR + '/.tern-config',
    CONF_DIR + '/ctags':                HOME_DIR + '/.ctags',
    CONF_DIR + '/agignore':             HOME_DIR + '/.agignore',
    CONF_DIR + '/gitconfig':            HOME_DIR + '/.gitconfig',
    CONF_DIR + '/global-gitignore':     HOME_DIR + '/.config/git/ignore',
    # File not in conf dir
    HOME_DIR + '/.dotfiles/zshrc':      HOME_DIR + '/.zshrc',
    HOME_DIR + '/.dotfiles/vimrc':      HOME_DIR + '/.config/nvim/init.vim',
    HOME_DIR + '/.dotfiles/pre-commit': HOME_DIR + '/.dotfiles/.git/hooks/pre-commit'
}

class TestMain(unittest.TestCase):
    @patch('os.makedirs')
    @patch('os.symlink')
    def test_main_link(self, os_symlink, os_makedirs):
        setup.main(False)
        for path, link in conf_files.items():
            os_makedirs.assert_any_call(os.path.dirname(path), exist_ok=True)
            os_symlink.assert_any_call(path, link)

    @patch('os.unlink')
    def test_main_unlink(self, os_unlink):
        setup.main(True)
        for _, link in conf_files.items():
            os_unlink.assert_any_call(link)


if __name__ == '__main__':
    unittest.main()
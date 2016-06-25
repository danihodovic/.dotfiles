#!/usr/bin/env python3.5
import os
import unittest
import sys
from unittest.mock import patch

repo_root = os.path.expanduser('~/.dotfiles')
sys.path.append(repo_root)

import setupSymlinks

min_version = 3.4
version = float(sys.version[0:3])
if version < min_version:
    print('Error: Python version {} detected, use at least version {}', version, min_version)
    sys.exit(1)

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
    CONF_DIR + '/Xresources':           HOME_DIR + '/.Xresources',
    CONF_DIR + '/i3-config':            HOME_DIR + '/.i3/config',
    CONF_DIR + '/vimperatorrc':         HOME_DIR + '/.vimperatorrc',
    CONF_DIR + '/profile':              HOME_DIR + '/.profile',
    # File not in conf dir
    HOME_DIR + '/.dotfiles/zshrc':      HOME_DIR + '/.zshrc',
    HOME_DIR + '/.dotfiles/vimrc':      HOME_DIR + '/.config/nvim/init.vim',
    HOME_DIR + '/.dotfiles/vimrc':      HOME_DIR + '/.vimrc',
    HOME_DIR + '/.dotfiles/pre-commit': HOME_DIR + '/.dotfiles/.git/hooks/pre-commit'
}

class TestMain(unittest.TestCase):
    def test_dict_equal(self):
        '''
        Ensures that the configuration files are the same as the ones defined in tests.
        Basically a double check
        '''
        assert(set(conf_files.items()) == set(setupSymlinks.conf_files.items()))

    @patch('os.remove')
    @patch('os.symlink')
    def test_main(self, os_symlink, os_remove):
        '''
        Ensures that delete and link is called, regardless of error
        '''
        setupSymlinks.main(verbose=False)

        for path, link in conf_files.items():
            os_remove.assert_any_call(link)
            os_symlink.assert_any_call(path, link)

        assert(os_remove.call_count == len(conf_files))
        assert(os_symlink.call_count == len(conf_files))


    @patch('os.remove')
    @patch('os.symlink')
    @patch('os.path.isdir')
    @patch('os.makedirs')
    def test_parent_directory_created(self, os_makedirs, os_path_isdir, _os_symlink, _os_remove):
        '''
        Ensures that the parent directory of the symlink is created if it doesnt exist
        '''
        os_path_isdir.return_value = False
        setupSymlinks.main(verbose=False)

        for _, link in conf_files.items():
            os_makedirs.assert_any_call(os.path.dirname(link))

        assert(os_makedirs.call_count == len(conf_files))


if __name__ == '__main__':
    unittest.main()

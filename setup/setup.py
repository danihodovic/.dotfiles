#!/usr/bin/env python3.5
'''
Script to setup all of the symlinks
'''
import os
import argparse

def _unlink(link):
    msg = ""
    try:
        msg = "Removing:" + link
        os.unlink(link)
    except OSError as err:
        msg = str(err)
    finally:
        print(msg)


def _createSymlink(src, dst):
    msg = ""
    try:
        msg = "[Success ] Creating symlink from: {} to: {}".format(src, dst)
        os.symlink(src, dst)
    except OSError as err:
        msg = str(err)
    finally:
        print(msg)

def main(clean):
    HOME_DIR = os.path.expandvars('${HOME}')
    CONF_DIR = HOME_DIR + '/.dotfiles/conf'

    # TODO: Add checks if I move conf files dirs
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
        # File not in conf dir
        HOME_DIR + '/.dotfiles/zshrc':      HOME_DIR + '/.zshrc',
        HOME_DIR + '/.dotfiles/vimrc':      HOME_DIR + '/.config/nvim/init.vim',
        HOME_DIR + '/.dotfiles/pre-commit': HOME_DIR + '/.dotfiles/.git/hooks/pre-commit'
    }

    for path, symlink in conf_files.items():
        if clean:
            _unlink(symlink)
        else:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            _createSymlink(path, symlink)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', dest="clean", action="store_true",
                        help="Delete existing symlinks")
    args = parser.parse_args()
    main(args.clean)


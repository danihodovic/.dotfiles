#!/usr/bin/env python3.5
'''
Script to setup all of the symlinks
'''
import os
import argparse

HOME_DIR     = os.path.expandvars('${HOME}')
DOTFILES_DIR = HOME_DIR + '/.dotfiles'
CONF_DIR     = HOME_DIR + '/.dotfiles/conf'

NVIMRC_FILE    = HOME_DIR + '/.dotfiles/vimrc'
NVIMRC_SYMLINK = HOME_DIR + '/.config/nvim/init.vim'

confFiles = ['inputrc', 'tmux.conf', 'sqliterc', 'jshintrc', 'pylintrc',
    'pythonrc', 'jsbeautifyrc', 'tern-config', 'ctags', 'agignore']

# DONT include ~/.bashrc here. Remember that we use the default bashrc which
# sources our bashrc
# DONT include vim stuff here. Neovim and Vim have different setups nowadays so
# it's not as easy as slapping on symlinks. The nvim setup is done in the
# installation scripts and I don't use vim anymore
others = {
    HOME_DIR +'/.dotfiles/zshrc': HOME_DIR + '/.zshrc',
}

def unlink(link):
    msg = ""
    try:
        msg = "Removing:" + link
        os.unlink(link)
    except OSError as err:
        msg = "{0}: {1}".format(err, link)
    finally:
        print(msg)

def createSymlink(src, dst):
    msg = ""
    try:
        msg = "[Success ] Creating symlink from: {} to: {}".format(src, dst)
        os.symlink(src, dst)
    except OSError as err:
        msg = "{0}: {1}".format(err, dst)
    finally:
        print(msg)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', dest="clean", action="store_true",
            help="Delete existing symlinks")
    args = parser.parse_args()

    if args.clean:
        for f in confFiles:
            symlink = HOME_DIR + "/." + f
            unlink(symlink)

        for _, symlinkPath in others.items():
            unlink(symlinkPath)

        unlink(os.path.expandvars('${HOME}/.config/nvim/init.vim'))

    else:
        for f in confFiles:
            realPath = CONF_DIR + "/" + f
            symlinkPath = HOME_DIR + "/." + f
            createSymlink(realPath, symlinkPath)

        for realPath, symlinkPath in others.items():
            createSymlink(realPath, symlinkPath)

        os.makedirs(os.path.dirname(NVIMRC_SYMLINK), exist_ok=True)
        createSymlink(NVIMRC_FILE, NVIMRC_SYMLINK)

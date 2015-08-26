#!/usr/bin/env python
'''
Script to setup all of the symlinks
'''
import os
import argparse

home    = os.path.expanduser("~")
confDir = os.path.expanduser("~/.dotfiles/conf")

confFiles = ['inputrc', 'tmux.conf', 'sqliterc', 'jshintrc', 'jsbeautifyrc', 'tern-config']

# DONT include ~/.bashrc here. Remember that we use the default bashrc which sources our bashrc
others = {
    '~/.dotfiles/vimrc' : '~/.vimrc',
    '~/.vimrc': '~/.nvimrc',
    '~/.vim': '~/.nvim'
    }

# Expand the strings to real paths
for realPath, symlinkPath in others.iteritems():
    others.pop(realPath)
    realPath = os.path.expanduser(realPath)
    others[realPath] = os.path.expanduser(symlinkPath)

def unlink(f):
    try:
        print "Removing:" + f
        os.unlink(f)
    except Exception, err:
        print err

def createSymlink(src, dst):
    try:
        print "Creating symlink from: {} to: {}".format(src, dst)
        os.symlink(src, dst)
    except Exception, err:
        print err


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', dest="clean", action="store_true", help="Delete existing symlinks")
    parser.add_argument('--symlink', dest="symlink", action="store_true", help="Setup symlinks")
    args = parser.parse_args()

    if args.clean:
        for f in confFiles:
            symlink = home + "/." + f
            unlink(symlink)

        for _, symlinkPath in others.iteritems():
            unlink(symlinkPath)

    if args.symlink:
        for f in confFiles:
            realPath = confDir + "/" + f
            symlinkPath = home + "/." + f
            createSymlink(realPath, symlinkPath)

        for realPath, symlinkPath in others.iteritems():
            createSymlink(realPath, symlinkPath)


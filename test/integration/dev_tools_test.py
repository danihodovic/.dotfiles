#!/usr/bin/env python3.5

import sys
import os
import pwd
import grp
import unittest
import getpass
import shutil
import re
import subprocess
import contextlib
from distutils.version import StrictVersion, LooseVersion

repo_root = os.path.expanduser('~/.dotfiles/install')
sys.path.append(repo_root)
import dev_tools

HOME = os.path.expanduser('~')
user = getpass.getuser()

min_version = 3.4
version = float(sys.version[0:3])
if version < min_version:
    print('Error: Python version {} detected, use at least version {}', version, min_version)
    sys.exit(1)

class IntegrationSuite(unittest.TestCase):
    def test_install_neovim(self):
        dev_tools.install_neovim()

        lines = subprocess.check_output(['pip', 'show', 'neovim']).decode('utf-8').splitlines()
        pip_neovim_version = lines[1].split(': ')[1]

        self.assertTrue(is_installed_pkg('neovim'))
        self.assertGreaterEqual(
            StrictVersion(pip_neovim_version),
            StrictVersion('0.2.0'),
            'pip neovim {} < 0.2.0'.format(pip_neovim_version)
        )


    def test_install_docker(self):
        dev_tools.install_docker()

        output = subprocess.check_output(['docker', '-v']).decode('utf-8')
        version = LooseVersion(output.split(' ')[2])
        self.assertGreaterEqual(version, LooseVersion('17.11.0'))

        self.assertEqual(shutil.which('docker-compose'), '/usr/local/bin/docker-compose')


    def test_install_fzf(self):
        dev_tools.install_fzf()
        self.assertTrue(os.path.isfile('/root/.fzf/bin/fzf-tmux'))

        output = subprocess.check_output(['/root/.fzf/bin/fzf', '--version']).decode('utf-8')
        version = output.split(' ')[0]
        self.assertGreaterEqual(StrictVersion(version), StrictVersion('0.17.3'))


    def test_install_vim_plug(self):
        dev_tools.install_vim_plug()
        self.assertTrue(os.path.isfile('/root/.config/nvim/autoload/plug.vim'))


    def test_install_antibody(self):
        dev_tools.install_antibody()
        self.assertTrue(os.path.isfile('/usr/local/bin/antibody'))

        output = subprocess.check_output(['antibody', '-v'], stderr=subprocess.STDOUT).decode('utf-8')
        version = output.split('\n')[0].split(' ')[2]
        self.assertGreaterEqual(StrictVersion(version), StrictVersion('3.4.3'))


    def test_install_hub(self):
        dev_tools.install_hub()

        output = subprocess.check_output(['hub', '--version']).decode('utf-8')
        version = output.split('\n')[1].split(' ')[2]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('2.3.0-pre10'))


    def test_install_gvm(self):
        dev_tools.install_gvm()

        output = subprocess.check_output([
            'bash', '-c', 'source /root/.gvm/scripts/gvm && gvm version'
        ]).decode('utf-8')
        version = output.split(' ')[3]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('v1.0.2'))


    def test_install_n(self):
        self.skipTest('Implement later')

        dev_tools.install_n()

        output = subprocess.check_output(['/root/.n/bin/n', '--version']).decode('utf-8')
        version = output.split('\n')[0]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('2.1.8'))


def is_installed_pkg(pkg):
    proc = subprocess.Popen(['apt-cache', 'policy', pkg], stdout=subprocess.PIPE)
    proc.stdout.readline()
    installed_str = proc.stdout.readline()
    proc.communicate()
    proc.wait()
    return b'none' not in installed_str

def find_owner(filename):
    return pwd.getpwuid(os.stat(filename).st_uid).pw_name

def find_group(filename):
    return grp.getgrgid(os.stat(filename).st_gid).gr_name

if __name__ == '__main__':
    unittest.main()

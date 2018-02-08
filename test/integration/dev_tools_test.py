#!/usr/bin/env python3.5

from distutils.version import StrictVersion, LooseVersion
import contextlib
import getpass
import grp
import os
import pwd
import re
import shutil
import subprocess
import sys
import unittest

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

class Suite(unittest.TestCase):
    def test_install_neovim(self):
        dev_tools.install_neovim()

        lines = subprocess.check_output(['pip', 'show', 'neovim'], encoding='utf-8').splitlines()
        pip_neovim_version = lines[1].split(': ')[1]

        self.assertTrue(is_installed_pkg('neovim'))
        self.assertGreaterEqual(
            StrictVersion(pip_neovim_version),
            StrictVersion('0.2.0'),
            'pip neovim {} < 0.2.0'.format(pip_neovim_version)
        )


    def test_install_docker(self):
        dev_tools.install_docker()

        docker_version = cmd_output('docker -v').split()[2]
        self.assertGreaterEqual(LooseVersion(docker_version), LooseVersion('17.11.0'))
        self.assertEqual(grp.getgrnam('docker').gr_mem, [user])

        docker_compose_version = cmd_output('docker-compose --version') \
            .split()[2] \
            .replace(',', '')
        self.assertGreaterEqual(LooseVersion(docker_compose_version), LooseVersion('1.19.0'))


    def test_install_fzf(self):
        dev_tools.install_fzf()

        version = cmd_output('~/.fzf/bin/fzf --version').split()[0]
        self.assertGreaterEqual(StrictVersion(version), StrictVersion('0.17.3'))


    def test_install_vim_plug(self):
        dev_tools.install_vim_plug()
        self.assertTrue(os.path.isfile(f'{HOME}/.config/nvim/autoload/plug.vim'))


    def test_install_antibody(self):
        dev_tools.install_antibody()

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

        version = cmd_output('bash -c "source ~/.gvm/scripts/gvm && gvm version"').split()[3]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('v1.0.2'))


    def test_install_n(self):
        dev_tools.install_n()

        output = subprocess.check_output('PATH=$HOME/.n/bin:$PATH n --version', shell=True).decode('utf-8')
        version = output.split('\n')[0]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('2.1.8'))


    def test_install_chrome(self):
        dev_tools.install_chrome()
        # If the bash command fails, we'll get an error. We could also use
        # `which`, but checking the version as a health check is consistent with
        # the other tests.
        subprocess.check_output(['google-chrome', '--version'])


    def test_install_i3_completions(self):
        dev_tools.install_i3_completions()
        self.assertTrue(os.path.isfile(f'{HOME}/.i3_completion.sh'))


    def test_install_diff_so_fancy(self):
        dev_tools.install_diff_so_fancy()

        # For some reason this doesn't output versions when the full integration
        # suite is ran, but does output versions when only this test is focused.
        result = subprocess.run('diff-so-fancy --version', shell=True, stderr=subprocess.PIPE)
        #  version = result.stderr.decode('utf-8').split('\n')[1].split()[2]
        #  self.assertGreaterEqual(LooseVersion(version), LooseVersion('1.1.1'))


    def test_install_tldr(self):
        dev_tools.install_tldr()

        # No versions for tldr bash
        result = subprocess.run('tldr')
        self.assertEqual(result.returncode, 0)


    def test_install_alacritty(self):
        dev_tools.install_alacritty()

        version = cmd_output('alacritty --version').split()[1]
        self.assertGreaterEqual(LooseVersion(version), LooseVersion('0.1.0'))

def cmd_output(cmd):
    return subprocess.check_output(cmd, shell=True, encoding='utf-8')

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

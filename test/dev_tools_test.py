#!/usr/bin/env python3.5

import sys
import os
import subprocess
import unittest
from unittest.mock import Mock, call, patch

repo_root = os.path.expanduser('~/.dotfiles/install')
sys.path.append(repo_root)

import dev_tools

if not sys.version.startswith('3.5'):
    print('Error: Use python3.5')
    sys.exit(1)

import dev_tools

class TestOK(unittest.TestCase):
    @unittest.skip('wip')
    def test_download_to_file(self):
        with patch('__main__.open'):
            with patch('urllib.request.urlopen') as urlopen_mock:
                import os, urllib, shutil
                os.path.dirname = Mock()
                os.path.isdir = Mock(return_value=False)
                os.path.isfile = Mock(return_value=False)
                os.makedirs = Mock()
                shutil.copyfileobj = Mock()

                dev_tools.download_to_file('url', 'file')

                self.assertEqual(os.path.dirname.call_args, call('file'))
                self.assertEqual(os.path.isdir.called, True)
                self.assertEqual(os.makedirs.called, True)
                self.assertEqual(os.path.isfile.call_args, call('file'))
                self.assertEqual(urlopen_mock.call_args, call('url'))
                #  self.assertEqual(open_mock.call_args, call('file', 'wb'))
                #  self.assertEqual(shutil.copyfileobj.call_args, call(urlopen_mock, open_mock))


if __name__ == '__main__':
    unittest.main()


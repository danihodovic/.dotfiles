#!/usr/bin/env python3.5

import subprocess
import unittest
from unittest.mock import Mock, call, patch

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

class TestInstallPip3(unittest.TestCase):
    @patch('subprocess.Popen')
    def test(self, popen):
        proc1 = Mock()
        proc1.wait = Mock(return_value=1)
        proc2 = Mock()
        proc2.wait = Mock(return_value=0)
        proc2.communicate = Mock(return_value=('', ''))

        popen.side_effect = [proc1, proc2]

        dev_tools.install_pip3()
        popen.assert_any_call('hash pip3', shell=True, stderr=-1, stdout=-1)
        popen.assert_any_call('sudo apt-get install python3-pip', shell=True, stderr=-1, stdout=-1)



class TestUpdateAlternativesPython3(unittest.TestCase):
    @patch('subprocess.Popen')
    def test(self, popen):
        proc = Mock()
        proc.wait = Mock(return_value=0)
        popen.return_value = proc
        dev_tools.update_alternatives_python3()

        cmdpy2 = 'sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1'
        cmdpy3 = 'sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1'
        cmdSetPy35 = 'sudo update-alternatives --set python /usr/bin/python3.5'
        cmd = '{} && {} && {}'.format(cmdpy2, cmdpy3, cmdSetPy35)
        popen.assert_called_with(cmd, shell=True, stderr=-1, stdout=-1)

class TestExceptionsRaisedOnError(unittest.TestCase):

    # Tests that if install_cmd helper fails the process throws an exception
    @patch('subprocess.Popen')
    def test_install_cmd_raises_exception(self, Popen):
        process_mock = Mock()
        process_mock.communicate = Mock(return_value=(b'stdout', b'stderr'))
        process_mock.wait = Mock(return_value=1)

        Popen.return_value = process_mock

        with self.assertRaises(subprocess.SubprocessError):
            dev_tools.install_cmd('foo', 'bar')


    @patch('dev_tools.download_to_file')
    @patch('subprocess.Popen')
    def test_install_knack_popen_raises_exception(self, Popen, _):
        process_mock = Mock()
        process_mock.communicate = Mock(return_value=(b'stdout', b'stderr'))
        process_mock.wait = Mock(return_value=1)

        Popen.return_value = process_mock

        with self.assertRaises(subprocess.SubprocessError):
            dev_tools.install_knack_font()


    @patch('subprocess.Popen')
    def test_install_tpm_raises_exception(self, Popen):
        process_mock = Mock()
        process_mock.communicate = Mock(return_value=(b'stdout', b'stderr'))
        process_mock.wait = Mock(return_value=1)

        Popen.return_value = process_mock

        with self.assertRaises(subprocess.SubprocessError):
            dev_tools.install_tpm()


if __name__ == '__main__':
    unittest.main()


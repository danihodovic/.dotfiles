#!/usr/bin/env python3.5

import os
import sys
import subprocess
import json

# todo:
# - Tick the task once it's downloaded :D

usage = '''
Parses a json response from the ticktick HTTP API and pulls
all the songs listed as the task title from Youtube.

Constraints:
- The task title needs to be the YouTube url
- The Docker daemon needs to be installed

Usage:
    {} file.json
'''.format(sys.argv[0])

if len(sys.argv) != 2:
    print(usage)
    sys.exit(1)

def is_task_completed(task):
    return task['completedTime'] is None

def download_youtube_song(task):
    url = task['title']
    cmd = [
        'docker', 'run',
        '-v', '{}:/home/user/mps/'.format(os.getcwd()),
        'andrey01/mps-youtube',
        'daurl', url
    ]
    proc = subprocess.Popen(cmd)
    proc.communicate()
    if proc.wait() != 0:
        return 'Error when downloading song: {}'.format(url)

if __name__ == '__main__':
    jsonfile = sys.argv[1]
    with open(jsonfile) as f:
        tasklist = json.load(f)
        successlist = [download_youtube_song(task) for task in tasklist]
        unsuccessful = [item is not None for item in successlist]

        print('Failed to download: \n')
        print('\n'.join(unsuccessful))

        print('Done. Successful downloads: {}, unsuccessful downloads: {}'.format(
            (len(tasklist) - len(unsuccessful)), len(unsuccessful)))

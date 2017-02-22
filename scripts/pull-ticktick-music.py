#!/usr/bin/env python3.5

import os
import subprocess
import json
import argparse

# todo:
# - Tick the task once it's downloaded :D

usage = '''
Parses a json response from the ticktick HTTP API and pulls
all the songs listed as the task title from Youtube.

Constraints:
- The task title needs to be the YouTube url
- The Docker daemon needs to be installed
'''

def is_task_completed(task):
    return task['progress'] != 0

def download_youtube_song(task):
    url = task['title']
    cmd = [
        'docker', 'run',
        '-v', '{}:/data'.format(os.getcwd()),
        '-u', '{}:{}'.format(os.getuid(), os.getgid()),
        'vimagick/youtube-dl',
        '-f', 'bestaudio[ext=m4a]', url
    ]
    proc = subprocess.Popen(cmd)
    proc.communicate()
    if proc.wait() != 0:
        raise Exception('Error when downloading song: {}'.format(url))

def main(filename):
    with open(filename) as f:
        tasklist = json.load(f)
        not_downloaded = [task for task in tasklist if not is_task_completed(task)]
        successful = 0
        errors = []

        for task in not_downloaded:
            try:
                download_youtube_song(task)
                successful = successful + 1
            except Exception as ex:
                errors.append(ex)

        print(errors)
        print('Done. Successful downloads: {}, unsuccessful downloads: {}'.format(
            successful, len(not_downloaded) - successful))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=usage)
    parser.add_argument('filename', type=str, help='the ticktick json file')
    args = parser.parse_args()
    main(args.filename)

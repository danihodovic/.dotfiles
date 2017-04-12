#!/usr/bin/env python3.5

import os
import sys
import re

if len(sys.argv) != 2:
    print('Usage {} <number>'.format(__file__))
    sys.exit(1)

def new_number(arg, current_number):
    if arg[0] == '+' or arg[0] == '-':
        increment_number = int(arg[1:])
        if arg[0] == '-':
            return current_number - increment_number
        else:
            return current_number + increment_number
    else:
        return int(arg)

path = os.path.expanduser("~") + '/.config/xfce4/terminal/terminalrc'
lines = []

with open(path, 'r+') as f:
    for line in f.readlines():
        m = re.search(r'FontName\D*(\d+)$', line)
        if m:
            old_number = int(m.groups()[0])
            new_number = new_number(sys.argv[1], old_number)
            new_line = re.sub(r'\d+$', str(new_number), line)
            lines.append(new_line)
        else:
            lines.append(line)

with open(path, 'w') as f:
    f.writelines(lines)

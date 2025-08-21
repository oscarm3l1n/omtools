#!/usr/bin/python3

"""
Usage:
    path/to/file/run.py --mouse
    path/to/file/run.py --no-mouse
"""

import subprocess
import argparse


class COLOR:
    GREEN = '\033[92m'
    END = '\033[0m'


SPEED_DESKTOP = 0.7
SPEED_TRACKPAD = -0.9

parser = argparse.ArgumentParser()
parser.add_argument(
    '--mouse',
    action=argparse.BooleanOptionalAction,
    help='--mouse for desktop speed. --no-mouse for trackpad',
)
args = parser.parse_args()

## main
speed = SPEED_DESKTOP if args.mouse else SPEED_TRACKPAD
subprocess.run(
    ['gsettings', 'set', 'org.gnome.desktop.peripherals.mouse', 'speed', f'{speed}'],
    check=True,
)
print(COLOR.GREEN + f'New speed set to {speed} [-1, 1].' + COLOR.END)

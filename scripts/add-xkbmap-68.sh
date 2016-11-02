#!/usr/bin/env bash

caps_lock_rules_file=/usr/share/X11/xkb/symbols/capslock
evdev_file=/usr/share/X11/xkb/rules/evdev

usage=$(cat<<EOF
This script will generate xkbmap configuration for 68 key MagicForce mechanical keyboard.
It remaps ESC to backticket and shift+backticket to tilde.

It writes to:
- $caps_lock_rules_file
- $evdev_file

Usage: sudo $0
EOF
)

set -e

if [ "$EUID" -ne 0 ]; then
  echo "$usage"
  exit 1
fi

swap_escape_68_rule=$(cat <<EOF

! option	=	symbols
hidden partial modifier_keys
xkb_symbols "swapescape68" {
    key <CAPS> { [ Escape ] };
    key <ESC>  { [ grave ] };
    key <TLDE> { [ grave, asciitilde ] };
};

EOF
)

swap_escape_68_rule_declaration=$(cat <<EOF

! option	=	symbols
  caps:swapescape68 = +capslock(swapescape68)

EOF
)

if grep -q swapescape68 "$caps_lock_rules_file"; then
  echo swapescape68 rule exists in "$caps_lock_rules_file"
else
  echo "Adding swapescape68 to $caps_lock_rules_file"
  echo "$swap_escape_68_rule" >> "$caps_lock_rules_file"
fi

if grep -q swapescape68 "$evdev_file"; then
  echo swapescape68 rule exists in "$evdev_file"
else
  echo "Adding caps:swapescape68 to $evdev_file"
  echo "$swap_escape_68_rule_declaration" >> "$evdev_file"
fi

sudo dpkg-reconfigure xkb-data
setxkbmap -option caps:swapescape68


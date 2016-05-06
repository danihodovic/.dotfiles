#!/usr/bin/env bash
logfile=/tmp/i3_vim_window_switch.log

log () {
  echo "$@" >> "$logfile"
}

direction=$1
active=$(xprop -id "$(xdotool getwindowfocus)" WM_NAME)

is_vim_window_regex='vim?"$'

shopt -s nocasematch;

log "$(date) - active window: ${active}"

if [[ $active =~ $is_vim_window_regex ]]; then
  key=''
  case $direction in
    up) key='k' ;;
    down) key='j' ;;
    left) key='h' ;;
    right) key='l' ;;
  esac
  xdotool getactivewindow key F6 o+w+e+"$key"
else
  i3-msg focus "$direction"
fi

shopt -u nocasematch;

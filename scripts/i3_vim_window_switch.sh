#!/usr/bin/env bash
logfile=/tmp/i3_vim_window_switch.log

log () {
  echo "$@" >> "$logfile"
}

direction=$1
i3-msg focus $direction
exit 0
active=$(xprop -id "$(xdotool getwindowfocus)" WM_NAME)

is_vim_window_regex='(n?vim?"$)|(WM_NAME\(STRING\) = "Terminal - \[1\] vi)'

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
  xdotool getactivewindow key F12+"$key"
else
  i3-msg focus "$direction"
fi

shopt -u nocasematch;

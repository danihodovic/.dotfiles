#!/usr/bin/env sh
echo foo >> /tmp/foo

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar 2>>/tmp/polybar.log &

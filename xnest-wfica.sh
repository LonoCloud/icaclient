#!/bin/bash

# Without strace, when starting from inside firefox, crashes with:
# XKB: Failed to compile keymap
strace -e "trace=" Xnest :1 -name Citrix -geometry 1280x1024 -noreset +bs &

while ! nc -z localhost 6001; do
  sleep 1
done

export DISPLAY=:1

exec /opt/Citrix/ICAClient/wfica.orig "$@"

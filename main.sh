#!/bin/bash -e

firefox --new-instance &

(
  while ! nc -z localhost 6001; do
    sleep 1
  done

  # match the color of the Windows target machine
  DISPLAY=:1 xsetroot -solid '#1d5f7a'
) &

Xnest :1 -name Citrix -geometry 1280x1024 -noreset +bs

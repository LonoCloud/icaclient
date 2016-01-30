#!/bin/bash

# --privileged is required for strace (see xnest-wfica.sh)
# volume mount X11 so firefox and Xnest can display windows

docker start icaclient >/dev/null || \
docker run -d --name icaclient \
  --privileged \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY="$DISPLAY" \
  mwaeckerlin/icaclient "$@"

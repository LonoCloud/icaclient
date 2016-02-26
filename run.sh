#!/bin/bash -e

# volume mount X11 so firefox and Xnest can display windows

docker start icaclient >/dev/null || \
docker run -d --name icaclient \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY="$DISPLAY" \
  mwaeckerlin/icaclient "$@"
docker exec -d icaclient /home/browser/xnest.sh

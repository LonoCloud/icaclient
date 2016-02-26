#!/bin/bash -e

export DISPLAY=:1

exec /opt/Citrix/ICAClient/wfica.orig "$@"

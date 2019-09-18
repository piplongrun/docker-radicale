#!/bin/sh

set -e

if [ -n "$GID" ]; then
    groupmod -o -g "$GID" radicale
fi

if [ -n "$UID" ]; then
    usermod -o -u "$UID" radicale
fi

# If no config file exists copy the default one to the config folder
if [[ ! -e /config/config ]]; then
    cp /opt/radicale/config /config
fi

# Re-set permission to the `radicale` user if current user is root
# This avoids permission denied if the data volume is mounted by root
if [ "$1" = 'radicale' ] && [ "$(id -u)" = '0' ]; then
    chown -R radicale:radicale /data
    exec su-exec radicale "$@"
else
  exec "$@"
fi

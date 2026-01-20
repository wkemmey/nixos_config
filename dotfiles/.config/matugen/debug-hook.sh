#!/usr/bin/env bash
# debug script to see what noctalia passes
echo "[$(date)] Debug hook called" >> /tmp/noctalia-debug.log
echo "  \$1 = '$1'" >> /tmp/noctalia-debug.log
echo "  \$@ = '$@'" >> /tmp/noctalia-debug.log
echo "  \$WALL = '$WALL'" >> /tmp/noctalia-debug.log
echo "  All args: $#" >> /tmp/noctalia-debug.log
for i in "$@"; do
    echo "  arg: '$i'" >> /tmp/noctalia-debug.log
done

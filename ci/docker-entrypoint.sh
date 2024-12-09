#!/bin/sh
set -e

# If command starts with 'envoy', prepend with su-exec to run as non-root
if [ "$1" = 'envoy' ]; then
    exec su-exec envoy "$@"
fi

# Otherwise, just execute the command
exec "$@"


#!/usr/bin/env bash
set -e

# Remove a potentially pre-existing server.pid
rm -f tmp/pids/server.pid

# Install missing gems (fast thanks to /usr/local/bundle volume)
bundle check || bundle install

exec "$@"

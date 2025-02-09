#!/bin/bash

trap 'handle_int' INT

handle_int() {
  echo "Received SIGINT, exiting..."
  exit
}

SHELL_DIR=$(dirname $(readlink -f "$0"))
REMOTE_HOST=N1
REMOTE_DIR=/opt/file_server/ACL4SSR/Clash

run_rsync() {
    echo "------------------------------------------------------------------------------------------------------------"
    date "+%Y-%m-%d %H:%M:%S"
    rsync -av --delete --progress --exclude={".*",".*/"}  "$SHELL_DIR"/ "$REMOTE_HOST:$REMOTE_DIR"
}

run_rsync; fswatch -i --exclude='.*' -i ".*/[^.]*\\\.(ini|list|yaml)$" -or $SHELL_DIR | while read f; do run_rsync; done

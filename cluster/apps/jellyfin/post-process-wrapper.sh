#!/usr/bin/env bash
exec > "/config/log/$(date +"%Y-%m-%d_%H-%M-%S")-post-process-wrapper-sh.log" 2>&1
if [ -z "${1}" ]; then
  echo "No {path} value was passed in by Jellyfin"
  exit 1
fi
/usr/bin/bash /config/scripts/post-process.sh "${1}"

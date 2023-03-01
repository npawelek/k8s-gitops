#!/bin/sh
#
# Workaround hard-coded 24-hour transcode cleanup by nuking files
# https://github.com/jellyfin/jellyfin/issues/3929

while true
do
  sleep 60
  if [ -n "$(find /transcode -type f -name '*.ts' -mmin +15)" ]; then
    date
    find /transcode -type f -name '*.ts' -mmin +15 -delete -exec echo "  purging {}" \;
  fi
done

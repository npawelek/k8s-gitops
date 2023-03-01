#!/bin/sh
#
# Workaround hard-coded 24-hour transcode cleanup by nuking files
# https://github.com/jellyfin/jellyfin/issues/3929

while true
do
  sleep 60
  find /transcode -type f -name '*.ts' -mmin +20 -delete -exec echo "$(date +%m-%d-%Y-%T) purging" {} \;
done

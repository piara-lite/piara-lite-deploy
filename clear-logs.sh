#!/bin/bash

this_file_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

df -h -x overlay -x tmpfs

rm -rf ./data/back/es/logs/*
rm -rf ./data/back/server-core/logs/*
rm -rf ./data/back/server-core/logs/background_jobs*
rm -rf ./data/back/server-core/logs/indexation*
rm -rf ./data/back/server-maintenance/logs/*
rm -rf ./data/back/server-maintenance/logs/background_jobs*
rm -rf ./data/back/server-maintenance/logs/indexation*

# Delete all of /var/log?
# https://serverfault.com/questions/185253/delete-all-of-var-log
# If you delete everything in /var/log, you will most likely end up with tons of error messages in very little time, since there are folders in there which are expected to exist (e.g. exim4, apache2, apt, cups, mysql, samba and more). Plus: there are some services or applications that will not create their log files, if they don't exist. They expect at least an empty file to be present. So the direct answer to your question actually is "Do not do this!!!".
# Cleaning all logs on a Linux system without deleting the files:
for CLEAN in $(find /var/log/ -type f); do cp /dev/null  $CLEAN; done

df -h -x overlay -x tmpfs

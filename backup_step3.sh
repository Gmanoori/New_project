#!/bin/bash


today_date=$(date '+%Y%m%d')
date=20250909
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source> <format>"
    exit 1
fi

mkdir -p backup/$today_date


echo "Hi, taking backup for $today_date"
source_path=$1
zip_format=$2
change_file=backup/$today_date/changes.txt
log_file=backup/logger.txt
check_changes="diff -r $source_path backup/$date/backup.$zip_format"

echo "backup/$date/backup.$zip_format"

diff -r "$source_path" "backup/$date/backup.$zip_format" > "$change_file"

<<com
if [ $? -eq 0 ]; then
  echo "Files are identical"
else
  touch $change_file
  echo "Files differ. Taking backup for $today_date"
  echo "Changes can be seen here: $change_file"
  zip -r backup/$today_date/backup.$zip_format $source_path
  echo "diff -q $source_path backup/$date/backup.$zip_format" > $log_file
  echo "Changelog updated at $log_file"
fi
com




#!/bin/bash


today_date=$(date '+%Y%m%d')


if [ $# -ne 3 ]; then
    echo "Usage: $0 <source> <format>"
    exit 1
fi

mkdir -p backup/$date

source_path=$1
zip_format=$2
date=$3
echo "Hi, taking backup for $date"

if diff -q $source_path <(unzip backup/$date/backup.$zip_format -d ./) > /dev/null; then
  echo "Files are identical"
else
  echo "Files differ. Taking backup for $today_date"
  zip -r backup/$date/backup.$zip_format $source_path
fi



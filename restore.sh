#!/bin/bash


today_date=$(date '+%Y%m%d')
echo "Todays Date: $today_date"
date="20250909"

days_to_subtract=$1

if [ -z "$days_to_subtract" ]; then
  echo "Please enter a specific date (YYYYMMDD):"
  read user_date
  echo "You entered: $user_date"
  
else
  new_date=$(date -d "-${days_to_subtract} days" +%Y%m%d)
  echo "Date $days_to_subtract days ago: $new_date"
  cd 
  find 
  unzip
fi




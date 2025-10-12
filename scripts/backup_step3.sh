#!/bin/bash
today_date=$(date '+%Y%m%d')

# Check for required arguments (source and format)
if [ $# -lt 2 ]; then
    echo "Usage: $0 <source> <format> [days_to_subtract]"
    echo "  days_to_subtract: Optional - number of days to subtract from current date"
    echo "                    If not provided, you will be prompted for a specific date"
    exit 1
fi

# Handle the date logic
if [ -n "$3" ] && [[ "$3" =~ ^[0-9]+$ ]]; then
    # If third argument is provided and is a number, calculate the date
    date=$(date -d "-$3 days" '+%Y%m%d')
    echo "Comparing with backup from $3 days ago: $date"
else
    # If no third argument or not a number, ask for specific date
    echo "Please enter a specific date to check with (YYYYMMDD):"
    read user_date
    # Validate date format
    if [[ "$user_date" =~ ^[0-9]{8}$ ]]; then
        date=$user_date
        echo "You entered: $date"
    else
        echo "Error: Invalid date format. Please use YYYYMMDD format."
        exit 1
    fi
fi

echo "Hi, checking archive for previous date: $date"
source_path=../$1
zip_format=$2
change_file=../backup/$today_date/changes.txt
log_file=../backup/logger.txt
check_changes="diff -r $source_path ../backup/$date/backup.$zip_format"

# Create temporary directory for unzipped files
temp_dir="../backup/temp_$(date +%s)"  # Create temp dir in backup folder with timestamp
mkdir -p "$temp_dir"

# Check if backup directory and file exist
backup_file="../backup/$date/backup.$zip_format"
if [ ! -d "../backup/$date" ]; then
    echo "Error: Backup directory for $date not found"
    rm -rf "$temp_dir"  # Clean up temp dir
    exit 1
elif [ ! -f "$backup_file" ]; then
    echo "Error: Backup file for $date not found"
    rm -rf "$temp_dir"  # Clean up temp dir
    exit 1
fi

echo "Found backup file. Unzipping for comparison..."
if ! unzip -q "$backup_file" -d "$temp_dir"; then
    echo "Error: Failed to unzip backup file $backup_file"
    rm -rf "$temp_dir"  # Clean up temp dir
    exit 1
fi

# List contents for verification (can be removed later)
echo "Successfully unzipped backup."

# Get the source directory name
source_dir_name=$(basename "$source_path")
echo "Comparing latest directory with backup for: $date"

# Perform the comparison
# Only capture content differences in change_file, redirect errors to null
if diff -r "$source_path" "$temp_dir/$source_dir_name" > "$change_file" 2>/dev/null; then
  echo "Files are identical. Skipping backup"
  rm -f "$change_file"  # Remove change file if no differences
else
  echo "Files differ for latest directory and backup for $date. Taking backup for $today_date"
  mkdir -p "../backup/$today_date"
  zip -r "../backup/$today_date/backup.$zip_format" "$source_path"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup taken due to changes detected" >> "$log_file"
  echo "Changelog updated at $log_file"
  echo "Changes can be seen here: $change_file"
fi

# Clean up temporary directory
rm -rf "$temp_dir"

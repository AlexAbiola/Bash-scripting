#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <directory_path>"
    exit 1
}

# Check if directory path is provided
if [ "$#" -ne 1 ]; then
    usage
fi

# Variables
dir_to_backup="$1"

# Validate the directory to backup
if [ ! -d "$dir_to_backup" ]; then
    echo "Error: Directory '$dir_to_backup' does not exist."
    exit 2
fi

# Create a timestamped backup folder inside dir_to_backup
timestamp=$(date +"%Y%m%d_%H%M%S")
backup_dir="$dir_to_backup/backup_$timestamp"
mkdir "$backup_dir"

# Perform the backup using rsync to avoid copying the backup folder into itself
rsync -av --exclude="$backup_dir" "$dir_to_backup/" "$backup_dir"

# Confirm backup completion
echo "Backup created: $backup_dir"

# Rotate backups - keep only the last 3 backups
backups=($(ls -dt $dir_to_backup/backup_*))
if [ "${#backups[@]}" -gt 3 ]; then
    backups_to_remove=(${backups[@]:3})
    for old_backup in "${backups_to_remove[@]}"; do
        rm -rf "$old_backup"
        echo "Removed old backup: $old_backup"
    done
fi


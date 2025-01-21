#!/bin/bash

# Directories to move files to
destinations=(
  "/mnt/up1/"
  "/mnt/up2/"
  "/mnt/up3/"
)

index=0

echo "Starting..."

while true; do
  # Wait for new .fpt files in the source directory
  file=$(inotifywait -q -e create,moved_to --format '%w%f' /root/bas/)
  
  if [[ $file == *.fpt ]]; then
    # Get the destination directory
    destination="${destinations[$index]}"
    
    # Move the file with a temporary name
    temp_file="${destination}$(basename "$file").tmp"
    mv "$file" "$temp_file"
    
    # Rename the file to its final name once fully moved
    final_file="${destination}$(basename "$file")"
    mv "$temp_file" "$final_file"
    
    echo "Moved $file to $final_file"
    
    # Increment index or reset to 0 if we've hit the end of the destinations array
    ((index=(index+1)%${#destinations[@]}))
  fi
done
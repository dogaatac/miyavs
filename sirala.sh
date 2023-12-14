#!/bin/bash

counter=1

for file in /root/.config/rclone/accounts/*.json; do
    if [ -f "$file" ]; then
        new_name="/root/.config/rclone/accounts/${counter}.json"
        mv "$file" "$new_name"
        ((counter++))
    fi
done

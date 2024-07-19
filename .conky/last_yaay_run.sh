#!/bin/zsh

# Get the path to the zsh history file
history_file="${HISTFILE:-$HOME/.zsh_history}"

# Read the history file and find the last occurrence of the yaay command without arguments
last_yaay_update=$(tac "$history_file" | awk -F ';' '/yaay[[:space:]]*$/ && !/history yaay/ {print $1; exit}')

# Extract the timestamp from the matched line
timestamp=$(echo "$last_yaay_update" | awk -F ':' '{print $2}')

# Define the reference timestamp (replace with your actual reference timestamp)
reference_timestamp=0

# Calculate the actual timestamp by adding the reference timestamp and the custom timestamp
actual_timestamp=$((reference_timestamp + timestamp))

# Convert the timestamp to a readable format
formatted_timestamp=$(date -d @$actual_timestamp "+%Y-%m-%d - %H:%M:%S")

# Print the formatted timestamp
echo "$formatted_timestamp"
# Run directly on the Terminal
#history -E | grep -E "[[:space:]]*yaay[[:space:]]*$" | grep -v "history yaay" | tail -n 1 | awk '{print $2,$3}'

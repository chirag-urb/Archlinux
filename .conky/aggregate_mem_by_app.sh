#!/bin/bash

# Calculate the width for the command name based on the desired total line width and memory column width
total_line_width=40
mem_column_width=1 # Adjust this width depending on how large the memory values are expected to be

# Get memory usage and command name, aggregate, and sort them
ps -eo rss,comm --no-headers | grep -v -E '^\s*0\s' | grep -v '\[' | awk -v total_width="$total_line_width" -v mem_width="$mem_column_width" '
{
    command_name = $2;
    gsub(/^\(/, "", command_name);
    gsub(/\)$/, "", command_name);
    mem[command_name] += $1;
}
END {
    for (command in mem) {
        command_width = total_width - mem_width;
        printf "%-" command_width "s %" mem_width ".2f MiB\n", command, mem[command] / 1024;
    }
}' | sort -rn -k2 | head -n 10

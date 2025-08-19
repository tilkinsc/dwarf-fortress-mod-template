#!/bin/bash

[ "$EUID" -eq 0 ] && { echo "Don't run me as root. I touch and write to files."; exit 1; }

: "${DWARF_FORTRESS_PATH:="$HOME/.local/share/Steam/steamapps/common/Dwarf Fortress"}"
: "${DF_OUTPUT_FILE:="./lualog.log"}"

# Parse arguments
LOG_TO_FILE=true
for arg in "$@"; do
    case "$arg" in
        --nologfile)
            LOG_TO_FILE=false
            ;;
    esac
done

# Try set Dwarf Fortress path if not set
if [ -z "$DWARF_FORTRESS_PATH" ]; then
    export DWARF_FORTRESS_PATH="$HOME/.local/share/Steam/steamapps/common/Dwarf Fortress"
fi

# Require a known Dwarf Fortress path
if [ ! -d "$DWARF_FORTRESS_PATH" ]; then
    echo "Dwarf Fortress path not found. Please set DWARF_FORTRESS_PATH to the root directory."
    echo "DWARF_FORTRESS_PATH=\"$DWARF_FORTRESS_PATH\""
    exit 1
fi

input_file_1="$DWARF_FORTRESS_PATH/gamelog.txt"
input_file_2="$DWARF_FORTRESS_PATH/lualog.txt"
touch "$input_file_1" "$input_file_2"
[ $LOG_TO_FILE ] && touch "$DF_OUTPUT_FILE"

# Optionally logs to output file
log_line() {
    if $LOG_TO_FILE; then
        tee -a "$DF_OUTPUT_FILE"
    else
        cat
    fi
}

# Function to clean up terminal on exit
cleanup() {
    echo "===> Log stopped at $(date +"[%Y-%m-%d %H:%M:%S]") <===" | log_line
    exit 0
}

# Loop and log to the buffer and local output file

echo "===> Log started at $(date +"[%Y-%m-%d %H:%M:%S]") <===" | log_line
last_line=""
repeat_count=0
current_line_logged=false
trap cleanup SIGINT SIGTERM
tail -n 0 -q -F "$input_file_1" "$input_file_2" | while IFS= read -r line; do
    timestamp=$(date +"[%Y-%m-%d %H:%M:%S]")
    if [[ "$line" == "$last_line" ]]; then
        ((repeat_count++))
        # Update the current line in terminal with repeat count
        if $current_line_logged; then
            # Move cursor up one line and clear it
            printf "\033[1A\033[2K"
        fi
        output_line="$timestamp $line [x$repeat_count]"
        echo "$output_line" | log_line
        current_line_logged=true
    else
        # New line is different
        if [[ -n "$last_line" ]]; then
            # If we had a previous line that wasn't logged with final count, log it
            if ! $current_line_logged; then
                echo "$timestamp $last_line" | log_line
            fi
        fi
        echo "$timestamp $line" | log_line
        # Update state
        last_line="$line"
        repeat_count=1
        current_line_logged=true
    fi
done

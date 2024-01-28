#!/bin/bash

# Path to your .cfg file
CFG_FILE="../printer.cfg"

# Output file
OUTPUT_FILE="./combined_printer.cfg"

# Regex to match the include pattern
PATTERN="^\[include (.*)\]$"

# Ensure the output file is empty
> "$OUTPUT_FILE"

# Function to append file contents to the output file
append_file() {
    if [ -f "$1" ]; then
        cat "$1" >> "$OUTPUT_FILE"
        echo -e "\n" >> "$OUTPUT_FILE"  # Add a newline for separation
    else
        echo "Warning: File $1 not found, skipping."
    fi
}

# Read each line of the .cfg file
while IFS= read -r line; do
    # Check if the line is an uncommented include statement
    if [[ $line =~ $PATTERN ]]; then
        # Extract the file path
        included_file="${BASH_REMATCH[1]}"
        # Resolve relative path from CFG_FILE directory
        included_file=$(dirname "$CFG_FILE")/"$included_file"
        # Append the content of the included file
        append_file "$included_file"
    fi
done < "$CFG_FILE"

echo "Concatenation complete. Output saved to $OUTPUT_FILE"


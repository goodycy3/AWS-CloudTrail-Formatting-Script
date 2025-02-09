
## This Script merge multiple JSON files into a single file (combined_logs.json) that can be used for further processing, such as ingestion into Splunk.

#!/bin/bash
set -e  # Exit the script immediately if any command exits with a non-zero status

# Directory containing the JSON files to be combined
SOURCE_DIR="Ransom_Logs_Extracted"

# Name of the output file that will store the combined JSON
OUTPUT_FILE="combined_logs.json"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist. Exiting."  # Inform the user and exit if the directory doesn't exist
    exit 1  # Exit with an error code
fi

# Create or overwrite the output file and initialize a JSON array
echo "[" > "$OUTPUT_FILE"

# Initialize a counter to manage commas between JSON objects
count=0

# Find all .json files in the source directory and append them to the output file
find "$SOURCE_DIR" -type f -name "*.json" | while read -r file; do
    if [ $count -ne 0 ]; then
        echo "," >> "$OUTPUT_FILE"  # Add a comma between JSON objects for valid JSON syntax
    fi
    cat "$file" >> "$OUTPUT_FILE"  # Append the content of the current JSON file to the output file
    count=$((count + 1))  # Increment the counter to track the number of appended files
done

# Close the JSON array
echo "]" >> "$OUTPUT_FILE"

# Print a success message with the name of the created file
echo "Combined JSON file created: $OUTPUT_FILE"

# The script extracts all .gz files from a specified base directory (Ransomware Logs) and saves the uncompressed files into a destination directory (Ransom_Logs_Extracted), ensuring the destination folder is created if it doesn't exist.

#!/bin/bash
set -e  # Exit immediately if any command exits with a non-zero status, ensuring the script stops on errors

# Base directory where the compressed log files are stored (update this path as necessary)
BASE_DIR="Ransomware Logs"

# Destination directory where the extracted log files will be stored
DEST_DIR="Ransom_Logs_Extracted"

# Check if the destination directory exists; if not, create it
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating destination directory: $DEST_DIR"  # Notify the user about directory creation
    mkdir -p "$DEST_DIR"  # Create the destination directory, including parent directories if needed
fi

# Extract all .gz files from the base directory into the destination directory
echo "Extracting all .gz files from: $BASE_DIR to: $DEST_DIR"  # Inform the user of the extraction process
find "$BASE_DIR" -type f -name "*.gz" | while read -r file; do
    # For each .gz file found, extract it into the destination directory
    echo "Extracting: $file to $DEST_DIR"  # Display the current file being processed
    gunzip -c "$file" > "$DEST_DIR/$(basename "${file%.gz}")"  # Extract and save the uncompressed file with the original name
done

# Notify the user that all files have been successfully extracted
echo "All .gz files have been successfully extracted to: $DEST_DIR"

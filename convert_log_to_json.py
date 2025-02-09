# The script processes a log file containing command execution data (admin-test-rb8bj2ghoyo6seu9edoqfsa9s4.log), extracts timestamps and associated commands, and converts the data into Newline-Delimited JSON (NDJSON) format for seamless ingestion into Splunk.

import json
import re

# Input log file and output JSON file
log_file = "admin-test-rb8bj2ghoyo6seu9edoqfsa9s4.log"  # The input log file containing command logs
output_json = "splunk_ready_logs.json"  # The output file for structured JSON data

# Regular expression pattern to match timestamps in the log file
timestamp_pattern = re.compile(r"Script started on (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\+\d{2}:\d{2})")

# List to store structured JSON data for Splunk ingestion
json_data = []

# Open the log file for reading
with open(log_file, "r", encoding="utf-8") as f:
    lines = f.readlines()  # Read all lines from the log file

    current_timestamp = None  # Variable to track the current timestamp
    for line in lines:
        line = line.strip()  # Remove leading/trailing whitespace from the line

        # Capture timestamp if the line matches the pattern
        match = timestamp_pattern.search(line)
        if match:
            current_timestamp = match.group(1)  # Extract the timestamp
            continue  # Skip to the next line

        # Skip empty lines or lines indicating the script has ended
        if not line or line.startswith("Script done"):
            continue

        # Assume the remaining line contains a command, associate it with the current timestamp
        json_data.append({
            "timestamp": current_timestamp,  # The timestamp associated with the command
            "command": line  # The command executed
        })

# Open the output file to write the extracted JSON data in NDJSON format
with open(output_json, "w", encoding="utf-8") as out_f:
    for entry in json_data:
        json.dump(entry, out_f)  # Write each JSON object to the file
        out_f.write("\n")  # Add a newline after each JSON object for NDJSON format

# Print summary of the conversion process
print(f"Converted {len(json_data)} log entries to JSON format.")
print(f"Output saved to {output_json}, ready for Splunk ingestion.")

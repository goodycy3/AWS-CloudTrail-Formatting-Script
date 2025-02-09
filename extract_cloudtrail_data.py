# This Python script processes a JSON file containing CloudTrail logs (combined_logs.json) to extract both event records and digest metadata into a format that is compatible with Splunk (splunk_ready_logs.json).

import json

# Input and output file paths
input_file = "combined_logs.json"  # The input file containing combined CloudTrail logs
output_file = "splunk_ready_logs.json"  # The output file to store extracted logs in Splunk-friendly format

def extract_cloudtrail_data(input_file, output_file):
    """
    Extracts both CloudTrail event records and digest metadata into Splunk-friendly format.
    """
    extracted_entries = []  # List to hold extracted CloudTrail event records and digest metadata

    try:
        # Open and read the input JSON file
        with open(input_file, 'r') as f:
            data = json.load(f)  # Load JSON data from the file

            if isinstance(data, list):  # Ensure the root of the JSON is a list (valid CloudTrail logs format)
                for entry in data:
                    if "Records" in entry and isinstance(entry["Records"], list):
                        # Extract CloudTrail event records if "Records" key exists and is a list
                        extracted_entries.extend(entry["Records"])
                    else:
                        # If no "Records" key, treat the entire entry as digest metadata
                        extracted_entries.append(entry)
            else:
                # Print an error if the JSON format is invalid (not a list at the root)
                print("Invalid JSON format: Root is not a list")

    except json.JSONDecodeError as e:
        # Handle and display JSON parsing errors
        print(f"Error reading {input_file}: {e}")
        return

    # Write the extracted data into the output file in Newline-Delimited JSON (NDJSON) format for Splunk
    with open(output_file, 'w') as f_out:
        for entry in extracted_entries:
            json.dump(entry, f_out)  # Write each entry as a JSON object
            f_out.write("\n")  # Add a newline after each entry for NDJSON format

    # Print a summary of the extraction process
    print(f"Extracted {len(extracted_entries)} entries from {input_file}")
    print(f"Processed logs saved in {output_file}, ready for Splunk ingestion.")

# Run the function
extract_cloudtrail_data(input_file, output_file)

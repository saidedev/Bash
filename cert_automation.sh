#!/bin/bash

# Prompt for the domain if not provided as an argument
if [ -z "$1" ]; then
    read -p "Enter the target domain: " DOMAIN
else
    DOMAIN=$1
fi

# Check if a domain was entered
if [ -z "$DOMAIN" ]; then
    echo "No domain provided. Exiting."
    exit 1
fi

# Fetch the subdomains using crt.sh
echo "Fetching subdomains for $DOMAIN from crt.sh..."

# Query crt.sh and extract unique subdomains
SUBDOMAINS=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | \
    jq -r '.[].name_value' | \
    sed 's/\*\.//g' | \
    sort -u)

# Check if any subdomains were found
if [ -z "$SUBDOMAINS" ]; then
    echo "No subdomains found for $DOMAIN."
    exit 0
fi

# Save subdomains to a file
OUTPUT_FILE="${DOMAIN}_subdomains.txt"
echo "$SUBDOMAINS" > "$OUTPUT_FILE"

# Print the result
echo "Subdomains found and saved to $OUTPUT_FILE:"
cat "$OUTPUT_FILE"
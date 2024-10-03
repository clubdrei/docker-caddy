#!/bin/sh

# Check if the ABUSEIPDB_API_DOWNLOAD environment variable is set to "true"
if [ "$ABUSEIPDB_API_DOWNLOAD" != "true" ]; then
    echo "ABUSEIPDB_API_DOWNLOAD is not set to 'true'. Skipping download."
    exit 0
fi

# Set the download URL for the AbuseIPDB blocklist
DOWNLOAD_URL="https://raw.githubusercontent.com/borestad/blocklist-abuseipdb/refs/heads/main/abuseipdb-s100-7777d.ipv4"

# Define the output file location
OUTPUT_FILE="/etc/caddy/rate_limited_ips/abuseip.txt"

# Check if curl is installed, if not, install it using apk
# In some alpine images curl does not get installed, even if set in the Dockerfile.
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed. Installing curl..."
    apk add --no-cache curl
    if [ $? -ne 0 ]; then
        echo "Failed to install curl."
        exit 1
    fi
else
    echo "curl is already installed."
fi

# Download the blocklist using curl
curl -fSL $DOWNLOAD_URL -o $OUTPUT_FILE

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Successfully downloaded the AbuseIPDB blocklist to $OUTPUT_FILE"
else
    echo "Failed to download the AbuseIPDB blocklist"
fi

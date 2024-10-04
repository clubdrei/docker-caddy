#!/bin/sh

# The first argument is the filename in the AbuseIPDB repository:
# https://github.com/borestad/blocklist-abuseipdb
DOWNLOAD_URL="https://raw.githubusercontent.com/borestad/blocklist-abuseipdb/refs/heads/main/${1}"

# The second argument is the output file
OUTPUT_FILE="${2}"

# Download the AbuseIPDB blocklist
TEMP_DOWNLOAD_FILE=$(mktemp)
if ! wget "${DOWNLOAD_URL}" -O "${TEMP_DOWNLOAD_FILE}"
then
    echo "Failed to download the AbuseIPDB blocklist"
    exit 1
fi

# Ensure that list has a plausible amount of entries
# On 2024-10-04 the list had 47703 entries, so checking for at least 10000 entries should be safe
LINE_COUNT=$(wc -l < "${TEMP_DOWNLOAD_FILE}")
if [ "${LINE_COUNT}" -lt 10000 ]
then
  echo "Too few IPs in the list (${TEMP_DOWNLOAD_FILE}), probably something went wrong with the download"
  exit 1
fi

echo "Successfully downloaded the AbuseIPDB blocklist to ${TEMP_DOWNLOAD_FILE}"

# Loop through each IP in the AbuseIPDB file, excluding comments, and add remote_ip before each IP so it can be imported in a Caddyfile
for IP in $(grep -hv '^#' "${TEMP_DOWNLOAD_FILE}"); do
    echo "remote_ip $IP" >> "${OUTPUT_FILE}"
done

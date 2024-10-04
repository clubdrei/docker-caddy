#!/bin/sh

#
# This script expects the following environment variables to exist:
# ABUSE_IP_DB_LOCAL_BASE_DIRECTORY
# ABUSE_IP_DB_LOCAL_FILENAME
# ABUSE_IP_DB_REMOTE_FILENAME
# ABUSE_IP_DB_MINIMUM_ENTRY_COUNT
#
# Check the Dockerfile for a detailed explanation of these environment variables
#

DOWNLOAD_URL="https://raw.githubusercontent.com/borestad/blocklist-abuseipdb/refs/heads/main/${ABUSE_IP_DB_REMOTE_FILENAME}"
OUTPUT_FILE="${ABUSE_IP_DB_LOCAL_BASE_DIRECTORY}/${ABUSE_IP_DB_LOCAL_FILENAME}"

# Download the AbuseIPDB blocklist
TEMP_DOWNLOAD_FILE=$(mktemp)
if ! wget "${DOWNLOAD_URL}" -O "${TEMP_DOWNLOAD_FILE}"
then
    echo "Failed to download the AbuseIPDB blocklist"
    exit 1
fi

LINE_COUNT=$(wc -l < "${TEMP_DOWNLOAD_FILE}")
if [ "${LINE_COUNT}" -lt "${ABUSE_IP_DB_MINIMUM_ENTRY_COUNT}" ]
then
  echo "Too few IPs in the list (${TEMP_DOWNLOAD_FILE}). Expected: ${ABUSE_IP_DB_MINIMUM_ENTRY_COUNT} Actual: ${LINE_COUNT}"
  exit 1
fi

echo "Successfully downloaded the AbuseIPDB blocklist to ${TEMP_DOWNLOAD_FILE}"

# Truncate the output file, otherwise running this script multiple times would append the result every time
true > "${OUTPUT_FILE}"

# Loop through each IP in the AbuseIPDB file, excluding comments, and add remote_ip before each IP so it can be imported in a Caddyfile
for IP in $(grep -hv '^#' "${TEMP_DOWNLOAD_FILE}"); do
    echo "remote_ip $IP" >> "${OUTPUT_FILE}"
done

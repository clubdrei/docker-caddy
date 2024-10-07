#!/bin/sh

# Microsoft landing page which contains the URL to the current public IP CSV
PAGE_URL="https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602"

# Microsoft blocks requests from wget without a valid user agent, so we fake one
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.60 Safari/537.36"

# Output file name
OUTPUT_FILE="${MICROSOFT_PUBLIC_IP_SPACE_LOCAL_BASE_DIRECTORY}/${MICROSOFT_PUBLIC_IP_SPACE_LOCAL_FILENAME}"

# Fetch the confirmation page content
PAGE_CONTENT=$(wget --user-agent="$USER_AGENT" -q -O - "${PAGE_URL}")

# Determine the current CSV URL and make sure it's the right download link
LATEST_CSV_URL=$(echo "${PAGE_CONTENT}" | grep -i 'data-bi-containername="download retry"' | grep -oE 'https://download\.microsoft\.com/download/[^"]+\.csv')

if [ -z "${LATEST_CSV_URL}" ]; then
    echo "Failed to determine the latest CSV URL"
    exit 1
fi

LATEST_CSV_DATA=$(wget --user-agent="$USER_AGENT" -q -O - "${LATEST_CSV_URL}")

LINE_COUNT=$(echo "${LATEST_CSV_DATA}" | wc -l)
if [ "${LINE_COUNT}" -lt 100 ]
then
  echo "Too few IPs in the list. Expected: 100 Actual: ${LINE_COUNT}"
  exit 1
fi

# Truncate the output file, otherwise running this script multiple times would append the result every time
true > "${OUTPUT_FILE}"

# Remove header row from the CSV
LATEST_CSV_DATA=$(echo "${LATEST_CSV_DATA}" | tail -n +2)

# Get first column (IP range)
LATEST_CSV_DATA=$(echo "${LATEST_CSV_DATA}" | cut -d',' -f1)

# Filter IPv6 addresses
LATEST_CSV_DATA=$(echo "${LATEST_CSV_DATA}" | grep -v ':')

echo "${LATEST_CSV_DATA}" | while read -r IP_RANGE
do
    echo "remote_ip ${IP_RANGE}" >> "${OUTPUT_FILE}"
done

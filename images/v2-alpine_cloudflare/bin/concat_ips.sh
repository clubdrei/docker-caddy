#!/bin/sh

# Define the directory where the IP files are located
IP_DIR="/etc/caddy/rate_limited_ips"

# Define the output rate_limit.caddy file
RATE_LIMIT_FILE="/etc/caddy/rate_limit.caddy"

# Start generating the new rate_limit.caddy file
cat <<EOF > $RATE_LIMIT_FILE
@rateLimitedIPs {
EOF

# Loop through each IP in the files, excluding comments, and add `remote_ip` before each IP
for IP in $(grep -hv '^#' $IP_DIR/*); do
    echo "    remote_ip $IP" >> $RATE_LIMIT_FILE
done

# Finish the rest of the rate_limit.caddy configuration, using Caddy environment variables syntax
cat <<EOF >> $RATE_LIMIT_FILE
}

rate_limit @rateLimitedIPs {
    zone default {
        key      {remote_ip}
        events   {\$RATE_LIMIT_EVENTS}  # Use Caddy's environment variable syntax
        window   {\$RATE_LIMIT_WINDOW}  # Use Caddy's environment variable syntax
        burst    100                   # Allow up to 100 burst requests
    }
}

# Optionally respond with 403 if rate limit is exceeded
respond @rateLimitedIPs 403
EOF

# Check if the file generation was successful
if [ $? -eq 0 ]; then
    echo "Successfully generated rate_limit.caddy"
else
    echo "Failed to generate rate_limit.caddy"
    exit 1
fi

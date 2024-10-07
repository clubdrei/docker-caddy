#!/bin/sh

#
# Execute this script with a cron job on the host system to keep the AbuseIPDB list up to date without pulling the latest image
#

# Update the AbuseIPDB blocklist
/usr/local/bin/abuseipdb_update.sh
# Reload caddy to apply the new updated AbuseIPDB list
caddy reload --config /etc/caddy/Caddyfile

FROM caddy:2-builder-alpine AS builder

# Build Caddy with required plugins
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit

FROM caddy:2-alpine

# Defines in which directory the blocklist should be stored. A subdirectory of /etc/caddy is recommended so the blocklist can be used in a Caddyfile (import abuseipdb/...)
ENV ABUSE_IP_DB_LOCAL_BASE_DIRECTORY="/etc/caddy/abuseipdb"
# The filename where the blocklist is stored inside of ABUSE_IP_DB_LOCAL_BASE_DIRECTORY
ENV ABUSE_IP_DB_LOCAL_FILENAME="s100-7d.ipv4.caddyfile"
# We use the 7d blocklist, because it's a good mix of "up to date" and "too shortlived"
# Check https://github.com/borestad/blocklist-abuseipdb for all available options
ENV ABUSE_IP_DB_REMOTE_FILENAME="abuseipdb-s100-7d.ipv4"
# As the minimum expected IPs/rows we use 20000, on 2024-10-04 the blocklist had 47703 rows so this should be safe
ENV ABUSE_IP_DB_MINIMUM_ENTRY_COUNT=20000

# Defines in which directory the Microsoft Public IP space should be stored.
# A subdirectory of /etc/caddy is recommended so the blocklist can be used in a Caddyfile (import microsoft-public-ip-space/...)
ENV MICROSOFT_PUBLIC_IP_SPACE_LOCAL_BASE_DIRECTORY="/etc/caddy/microsoft-public-ip-space"
# The filename where the Microsoft Public IP Space is stored inside of MICROSOFT_PUBLIC_IP_SPACE_LOCAL_BASE_DIRECTORY
ENV MICROSOFT_PUBLIC_IP_SPACE_LOCAL_FILENAME="current.caddyfile"

# Copy the caddy binary from the builder image
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Add AbuseIPDB scripts
COPY /images/v2-alpine_cloudflare_rate-limit/bin/abuseipdb_cron.sh /usr/local/bin/
COPY /images/v2-alpine_cloudflare_rate-limit/bin/abuseipdb_update.sh /usr/local/bin/
# Ensure the AbuseIPDB base directory exists
RUN mkdir "${ABUSE_IP_DB_LOCAL_BASE_DIRECTORY}"
# Download & process the selected AbuseIPDB blocklist
RUN /usr/local/bin/abuseipdb_update.sh

# Add Microsoft Public IP Space scripts
COPY /images/v2-alpine_cloudflare_rate-limit/bin/microsoft-public-ip-space_cron.sh /usr/local/bin/
COPY /images/v2-alpine_cloudflare_rate-limit/bin/microsoft-public-ip-space_update.sh /usr/local/bin/
# Ensure the Microsoft Public IP Space base directory exists
RUN mkdir "${MICROSOFT_PUBLIC_IP_SPACE_LOCAL_BASE_DIRECTORY}"
# Download & process the Microsoft Public IP space
RUN /usr/local/bin/microsoft-public-ip-space_update.sh

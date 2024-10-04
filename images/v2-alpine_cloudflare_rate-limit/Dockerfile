FROM caddy:2-builder-alpine AS builder

# Build Caddy with required plugins
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit

# Add the abuseipdb download script
COPY /images/v2-alpine_cloudflare_rate-limit/bin/download_abuseipdb.sh /usr/bin/download_abuseipdb.sh
RUN chmod +x /usr/bin/download_abuseipdb.sh
RUN /usr/bin/download_abuseipdb.sh "abuseipdb-s100-7d.ipv4" "/tmp/s100-7d.ipv4.Caddyfile"

FROM caddy:2-alpine

# Copy the caddy binary from the builder image
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Add the default rate limited IPs files
RUN mkdir "/etc/caddy/abuseipdb"
COPY --from=builder /tmp/s100-7d.ipv4.Caddyfile /etc/caddy/abuseipdb/

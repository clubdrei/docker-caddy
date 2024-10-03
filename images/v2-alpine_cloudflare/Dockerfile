FROM caddy:2-builder-alpine AS builder

# Build Caddy with required plugins
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/mholt/caddy-ratelimit

RUN apk update && apk add --no-cache curl

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Create a directory to store the rate-limited IPs
RUN mkdir -p /etc/caddy/rate_limited_ips

# Add the default rate limited IPs files
COPY rate_limited_ips/ /etc/caddy/rate_limited_ips/

# Expose the directory for IP files so they can be modified externally
VOLUME /etc/caddy/rate_limited_ips

# Add the abuseipdb download script
COPY bin/download_abuseipdb.sh /usr/bin/download_abuseipdb.sh
RUN chmod +x /usr/bin/download_abuseipdb.sh

# Add concat IP lists script
COPY bin/concat_ips.sh /usr/bin/concat_ips.sh
RUN chmod +x /usr/bin/concat_ips.sh

# Start
CMD /usr/bin/download_abuseipdb.sh && /usr/bin/concat_ips.sh && caddy run --config /etc/caddy/Caddyfile

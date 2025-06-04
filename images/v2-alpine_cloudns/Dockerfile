FROM caddy:2-builder-alpine AS builder
# Use custom version of libdns/cloudns: https://github.com/caddy-dns/cloudns/issues/1#issuecomment-2892861238
RUN xcaddy build --with github.com/caddy-dns/cloudns --replace github.com/libdns/cloudns=github.com/worr/cloudns@8b0aa5e

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

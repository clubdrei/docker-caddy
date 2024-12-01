FROM caddy:2-builder-alpine AS builder
RUN xcaddy build --with github.com/anxuanzi/caddy-dns-ClouDNS

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

FROM caddy:2-builder-alpine AS builder
RUN xcaddy build --with github.com/caddyserver/cache-handler \
    --with github.com/darkweak/storages/nuts/caddy \
    --with github.com/darkweak/storages/simplefs/caddy

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

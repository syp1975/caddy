ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-authorize \
    --with github.com/caddy-dns/duckdns

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]


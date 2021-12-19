ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin \
    --with github.com/abiosoft/caddy-exec \
    --with github.com/greenpau/caddy-auth-portal \
    --with github.com/greenpau/caddy-authorize \
    --with github.com/caddy-dns/duckdns
RUN /usr/bin/caddy list-modules -packages -versions > /list-modules.txt
	
FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /list-modules.txt /config/caddy/list-modules.txt

CMD ["caddy", "docker-proxy"]

ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}
LABEL org.opencontainers.image.authors="syp1975@gmail.com"
COPY build/${TARGETPLATFORM}/caddy /usr/bin/caddy
COPY build/list-modules.txt /list-modules.txt
CMD ["caddy", "docker-proxy"]

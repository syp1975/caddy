ARG CADDY_VERSION=2
ARG TARGETPLATFORM
FROM caddy:${CADDY_VERSION}
LABEL org.opencontainers.image.authors="syp1975@gmail.com"
COPY build/${TARGETPLATFORM}/caddy /usr/bin/caddy
COPY list-modules.txt /list-modules.txt
CMD ["caddy", "docker-proxy"]

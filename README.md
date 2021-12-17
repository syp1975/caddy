# Caddy v2 with docker proxy and some other plugins
Packaged as a docker image: `ghcr.io/syp1975/caddy`.

I use it to proxy containerized apps to my [Duck DNS](https://www.duckdns.org) subdomain trough a secure connection with a wildcard certificate issued by [Let's Encrypt](https://letsencrypt.org).

Image is automatically rebuilt when the base image `caddy:2-builder` or plugins are updated.

|Component|Description|
|---|---|
|[caddy](https://caddyserver.com)|Open source web server|
|[caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy)|Caddy as a reverse proxy for Docker|
|[duckdns](https://github.com/caddy-dns/duckdns)|Duck DNS module for Caddy|
|[caddy-auth-portal](https://github.com/greenpau/caddy-auth-portal)|Authentication Plugin for Caddy v2|
|[caddy-authorize](https://github.com/greenpau/caddy-authorize)|Authorization Plugin for Caddy v2 (JWT/PASETO)|
|[caddy-exec](https://github.com/abiosoft/caddy-exec)|Caddy v2 module for running one-off commands|

### Run caddy server
```
docker network create caddy
docker run --name caddy -d --restart=unless-stopped \
  --network=caddy -p 443:443 -p 80:80 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -l caddy.acme_dns='duckdns your_duckdns_token' \
  -l caddy.email=your_email \
  -e CADDY_INGRESS_NETWORKS=caddy \
  ghcr.io/syp1975/caddy
```

### Run a containerized app behind the proxy
```
docker run --name app_name -d \
  --network=caddy \
  -l caddy='*.your_sub_domain.duckdns.org' \
  -l caddy.@app_name.host='app_name.your_sub_domain.duckdns.org' |
  -l caddy.reverse_proxy='@app_name {{upstreams app_port}}' \
  app_image
```
\* There is no need to publish *app_port*, caddy proxy server already has access to the app port trough the caddy network

And your application will be proxied at `https://app_name.your_sub_domain.duckdns.org`

### TODO
- Finish automatic image building action
- Configure authentication

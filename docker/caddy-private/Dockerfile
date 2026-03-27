FROM caddy/ingress:v0.2.1

RUN apk add --no-cache ca-certificates

COPY infra/certs/cloudstrife-ca.crt /usr/local/share/ca-certificates/cloudstrife-ca.crt

RUN update-ca-certificates
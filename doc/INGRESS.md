# Public and private ingresses

## Install caddy ingress with Helm

### Private

Because kubernetes does not trust on our private certificate, I have to install my certificate authority

```shell
kubectl create namespace caddy-private
```

```shell
kubectl -n caddy-private create secret generic internal-acme-root \
  --from-file=acme-root.pem=cloudstrife-ca.crt
```

The private ingress is single stack ipv6-only, but need to be configured as **dual stack** because **single stack** is interpreted as **IPv4-only**.

```shell
helm install caddy-private \
  --namespace caddy-private \
  --create-namespace \
  --repo https://caddyserver.github.io/ingress/ \
  -f kube/caddy-ingress-private-values.yaml \
  caddy-ingress-controller
```

### Public

Public is indeed **dual stack** remember that the **Public IPv4 here** isn't really public and shoud be addressed as a NAT forward on routing for proper usage.

```shell
helm install caddy-public \
  --namespace caddy-public \
  --create-namespace \
  --repo https://caddyserver.github.io/ingress/ \
  -f kube/caddy-ingress-public-values.yaml \
  caddy-ingress-controller
```

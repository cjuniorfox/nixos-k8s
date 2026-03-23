# Public and private ingresses

## Install caddy ingress with Helm

Private

```shell
helm install caddy-private \
  --namespace caddy-private \
  --create-namespace \
  --repo https://caddyserver.github.io/ingress/ \
  -f kube/caddy-ingress-private-values.yaml \
  caddy-ingress-controller
```

Public

```shell
helm install caddy-public \
  --namespace caddy-public \
  --create-namespace \
  --repo https://caddyserver.github.io/ingress/ \
  -f kube/caddy-ingress-public-values.yaml \
  caddy-ingress-controller
```

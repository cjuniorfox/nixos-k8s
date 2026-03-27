# MetalLB

MetalLB provides the IP addresses for LoadBalancer services (used by the Caddy ingress controllers).

## Install MetalLB

Official documentation [here](https://metallb.io/installation/).

```shell
METALLB_VERSION=v0.15.3
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml
```

The controller normally auto-creates the `memberlist` secret on first start. If pods get
stuck (e.g. the worker node joined after MetalLB was deployed and CNI wasn't ready yet),
create it manually and restart:

```shell
kubectl create secret generic memberlist \
  --from-literal=secretkey="$(openssl rand -base64 128)" \
  -n metallb-system
kubectl -n metallb-system delete pods --all
```

Wait for the controller and speaker pods to be ready:

```shell
kubectl -n metallb-system wait --for=condition=ready pod --selector=app=metallb --timeout=120s
```

## Apply IP address pools

Two pools are defined:

- **private-v6-pool** — ULA range `fd38:82fc:4248:44:1::100-150`, announced on `ens18` (VMS network)
- **public-v6-pool** — GUA range `2001:470:e309:88:1::100-150` + IPv4 `172.16.88.100-150`, announced on `ens19` (DMZ network)

```shell
kubectl apply -f kube/metallb-private-public-pools.yaml
```

Verify pools and advertisements:

```shell
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
```

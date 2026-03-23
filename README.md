# NixOS Kubernetes Network Layout

This repository contains a NixOS-based Kubernetes setup with:

- Calico for cluster pod networking
- MetalLB for external `LoadBalancer` IP allocation
- Caddy as the ingress controller
- Separate private and public ingress entrypoints

The configuration is split between NixOS host definitions in `infra/` and Kubernetes manifests in `kube/`.

## Architecture

The stack is easier to understand in layers.

### 1. Internal cluster networking

This is the part that lets pods start, receive IP addresses, and talk to each other across nodes.

Components:

- Tigera operator
- Calico installation CR in [kube/calico-installation-dualstack.yaml](kube/calico-installation-dualstack.yaml)

What it provides:

- Kubernetes CNI plugin
- Pod IP allocation
- Cross-node pod connectivity
- CNI binaries on each node under `/opt/cni/bin`, including `calico` and `calico-ipam`

Without this layer working, normal pods cannot start.

### 2. External service IP allocation

This is the part that makes Kubernetes `LoadBalancer` Services reachable from your real networks.

Components:

- MetalLB native deployment
- `memberlist` secret for MetalLB speaker/controller coordination
- Address pools and advertisements in [kube/metallb-private-public-pools.yaml](kube/metallb-private-public-pools.yaml)

What it provides:

- External IP allocation for `LoadBalancer` Services
- L2 advertisement on the correct network interface
- Separation between private and public reachable addresses

Important dependency:

- Calico must already be healthy on all nodes, otherwise MetalLB controller pods may fail to start

### 3. HTTP and HTTPS ingress

This is the part that actually receives web traffic and routes it to applications.

Components:

- `caddy-private` Helm release
- `caddy-public` Helm release
- Values files:
  - [kube/caddy-ingress-private-values.yaml](kube/caddy-ingress-private-values.yaml)
  - [kube/caddy-ingress-public-values.yaml](kube/caddy-ingress-public-values.yaml)

What it provides:

- One ingress controller for private/internal hostnames
- One ingress controller for public hostnames
- Routing based on Kubernetes `Ingress` resources

Important distinction:

- MetalLB gives the Caddy Services reachable IPs
- Caddy receives HTTP/HTTPS traffic on those IPs
- Your app `Ingress` objects tell Caddy where to send the traffic

### 4. Application exposure

Applications are exposed in two parts:

1. A Deployment and Service for the app itself
2. An `Ingress` object that routes a hostname to that Service

Example files:

- [kube/caddy-test.yaml](kube/caddy-test.yaml): example application and Service
- [kube/caddy-test-private-ingress.yaml](kube/caddy-test-private-ingress.yaml): route `*.vms.lan` through `caddy-private`
- [kube/caddy-test-public-ingress.yaml](kube/caddy-test-public-ingress.yaml): route `*.juniorfox.net` through `caddy-public`

These test files are not part of the ingress infrastructure itself. They are example workloads used to prove that the ingress stack is working end to end.

## Network model

The current setup separates traffic into two networks:

- Private network on `ens18`
- Public or DMZ network on `ens19`

MetalLB pools:

- `private-v6-pool`
  - IPv6 ULA range for internal access
  - Advertised on `ens18`
- `public-v6-pool`
  - Public IPv6 range and DMZ IPv4 range
  - Advertised on `ens19`

This means:

- internal services can be exposed only to the private network
- public services can be exposed on the DMZ or public-facing network

## Typical flow

The normal setup flow is:

1. Bring up the NixOS hosts from `infra/`
2. Install Tigera operator and apply Calico configuration
3. Verify Calico is healthy on all nodes
4. Install MetalLB
5. Create the `memberlist` secret if MetalLB did not create it automatically
6. Apply MetalLB address pools and L2 advertisements
7. Install the private and public Caddy ingress controllers
8. Deploy an app Service and its matching `Ingress`

## Repository layout

- [infra/flake.nix](infra/flake.nix): Nix flake entrypoint
- [infra/common.nix](infra/common.nix): shared NixOS settings
- [infra/networking.nix](infra/networking.nix): host networking settings
- [infra/modules/kubernetes/master.nix](infra/modules/kubernetes/master.nix): control plane Kubernetes config
- [infra/modules/kubernetes/worker.nix](infra/modules/kubernetes/worker.nix): worker Kubernetes config
- [infra/hosts/k8s-control/configuration.nix](infra/hosts/k8s-control/configuration.nix): control plane host
- [infra/hosts/k8s-worker-1/configuration.nix](infra/hosts/k8s-worker-1/configuration.nix): worker host
- [kube/calico-installation-dualstack.yaml](kube/calico-installation-dualstack.yaml): Calico installation
- [kube/metallb-private-public-pools.yaml](kube/metallb-private-public-pools.yaml): MetalLB IP pools and advertisements
- [doc/INGRESS.md](doc/INGRESS.md): install notes for Caddy ingress and MetalLB

## Removing resources

Common cleanup patterns:

- Delete resources created from a manifest:

```shell
kubectl delete -f kube/caddy-test.yaml
kubectl delete -f kube/caddy-test-private-ingress.yaml
kubectl delete -f kube/caddy-test-public-ingress.yaml
```

- Uninstall Helm-managed ingress controllers:

```shell
helm uninstall caddy-private -n caddy-private
helm uninstall caddy-public -n caddy-public
```

- Remove a whole namespace:

```shell
kubectl delete namespace caddy-test
```

## Mental model summary

- Calico: internal Kubernetes network
- MetalLB: external IP allocation for `LoadBalancer` Services
- Caddy ingress: HTTP and HTTPS entrypoint
- App Ingress objects: hostname routing rules to Services
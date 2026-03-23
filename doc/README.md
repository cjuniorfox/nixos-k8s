# Basic Howto on Kubernetes

## Step by step

1. [Configure Control Node](CONTROL.md): Master node consisting on The initial kubernetes installation itself.
2. [Add Workers nodes](WORKER.md)
3. [Tigera and Calico Installation](CALICO-CNI.md): Network Stack. Cluster pod networking.
4. [Metallb](METALLB.md): External IP Allocation.
5. [Ingress](INGRESS.md): HTTP/HTTPS services that receives web traffic and routes to its application.

## Sanity Check

1. `kubectl get nodes -o wide`
2. `kubectl -n calico-system get pods`
3. `kubectl -n metallb-system get pods`
4. `kubectl get ipaddresspools -n metallb-system`
5. `kubectl get l2advertisements -n metallb-system`
6. `kubectl get svc -n caddy-private`
7. `kubectl get svc -n caddy-public`

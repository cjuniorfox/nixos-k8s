# Network Infrastructure

## Installation

### 1. Install Tigera operator

```shell
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
```

Check for its installation

```shell
kubectl get pods -n tigera-operator
NAME                               READY   STATUS    RESTARTS   AGE
tigera-operator-7c4b87d999-fxj6p   1/1     Running   0          3m22s
```

If there's some error, restart kubernetes

```shell
sudo systemctl restart kubelet.service
```

### 2. Install the dual stack network calico installation (creating the IPPools)

```shell
kubectl apply -f kube/calico-installation-dualstack.yaml
```

Wait for the calico installation to complete

```shell
kubectl get pods -n calico-system -w
NAME                                       READY   STATUS    RESTARTS   AGE
calico-kube-controllers-864f7b4d74-m6fsj   1/1     Running   0          2m4s
calico-node-6z7v4                          1/1     Running   0          2m4s
calico-typha-5fc4494475-q6rx7              1/1     Running   0          2m4s
csi-node-driver-pkcdl                      2/2     Running   0          2m4s
```

## Validation

Check the effectiveness of the installation

```shell
kubectl get installation default -o yaml
```

The the IPPools created by the operator

```shell
kubectl get ippools.crd.projectcalico.org -o wide
kubectl get ippools.crd.projectcalico.org -o yaml
```

Check the CIDRPods for v4/v6

```shell
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"  podCIDRs="}{.spec.podCIDRs}{"\n"}{end}'
```

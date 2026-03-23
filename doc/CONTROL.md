# NixOS Kubernetes configuration

## Configure kubectl

```shell
sudo KUBECONFIG=/etc/kubernetes/cluster-admin.kubeconfig \
kubectl config view --raw --flatten > ~/.kube/config
```

Remotely (through SSH)

```shell
ssh junior@k8s-control.vms.lan \
"sudo KUBECONFIG=/etc/kubernetes/cluster-admin.kubeconfig kubectl config view --raw --flatten" \
> ~/.kube/config
```
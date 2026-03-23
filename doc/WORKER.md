# K8S Worker

## Join the cluster

On `control`

Read the `apitoken.secret` and copy somewhere else

```shell
sudo cat /var/lib/kubernetes/secrets/apitoken.secret
```

On `worker`

```shell
echo "PASTE_THE_TOKEN_HERE" | sudo nixos-kubernetes-node-join
```

After that, check nodes avaiability

```shell
kubectl get nodes -o wide
```
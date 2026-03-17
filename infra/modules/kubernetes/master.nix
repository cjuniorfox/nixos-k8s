{ config, pkgs, ... }:
  {
    services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiserver.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    # Install Calico instead of Flannel for networking
    flannel.enable = false;
    # Calico installation can be done by applying the manifest directly from the URL:
    # kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

    addonManager.enable = true;

    apiserver.allowPrivileged = true;
  };

  networking.firewall.allowedTCPPorts = [
    22
    6443
    2379
    2380
    10250
    10257
    10259
  ];
}
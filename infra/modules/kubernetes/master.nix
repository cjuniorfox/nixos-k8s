{ config, pkgs, ... }:

{
  services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    # Dual stack cluster networks
    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiserver.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    # Disable flannel so we can install Calico manually
    flannel.enable = false;

    addonManager.enable = true;

    apiserver.allowPrivileged = true;
    kubelet = {
      cni = {
        packages = [ pkgs.cni-plugins ];
        binDir = "/opt/cni/bin";
        confDir = "/etc/cni/net.d";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /opt/cni/bin 0755 root root -"
  ];

  networking.firewall.allowedTCPPorts = [
    22
    6443
    2379
    2380
    10250
    10257
    10259
    179
  ];

  
}
{ config, pkgs, ... }:

{
  services.kubernetes = {
    roles = [ "master" "node" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    # Dual stack cluster networks
    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiserver.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    # Disable flannel so we can install Calico manually
    flannel.enable = false;

    addonManager.enable = true;

    # Calico node requires privileged containers; disable PSP admission if present.
    apiserver.disableAdmissionPlugins = [
      "PodSecurityPolicy"
    ];

    kubelet = {
      cni = {
        configDir = "/var/lib/cni/net.d";
        packages = [ pkgs.cni-plugins ];
      };
    };

  };

  systemd.tmpfiles.rules = [
    "d /opt/cni/bin 0755 root root -"
    "d /var/lib/cni/net.d 0755 root root -"
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
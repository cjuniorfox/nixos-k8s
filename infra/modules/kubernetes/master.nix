{ config, pkgs, ... }:
  {
    services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiServer.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    addonManager.enable = true;
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
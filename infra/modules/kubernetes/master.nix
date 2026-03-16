{ config, pkgs, ... }:
  {
    services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;
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
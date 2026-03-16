{config, pkgs, ... }:
{
  services.kubernetes = {
    roles = [ "node" ];
    masterAddress = "k8s-control.vms.lan";
  };
  
  networking.firewall.allowedTCPPorts = [
    22
    10250
  ];

  networking.firewall.allowedTCPPortRanges = [
    { from = 30000; to = 32767; }
  ];

}
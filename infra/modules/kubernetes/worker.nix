{config, pkgs, ... }:
{
  services.kubernetes = {
    roles = [ "node" ];
    masterAddress = "k8s-control.vms.lan";

    flannel.enable = false;

    kubelet = {
      cni = {
        configDir = "/var/lib/cni/net.d";
        packages = lib.mkForce [ ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedTCPPortRanges = [
      { from = 30000; to = 32767; }
    ];
  };
}
{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
      ../../modules/kubernetes/master.nix
      ../../networking.nix
      ../../storage.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "k8s-control";
  networking.interfaces.ens19.ipv4.addresses = [ { address = "172.16.88.11"; prefixLength = 24; } ];
  networking.interfaces.ens19.ipv4.routes = [ { address = "172.16.88.1"; prefixLength = 24; } ];
}
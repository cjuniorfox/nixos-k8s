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
  networking.interfaces.ens19.ipAddresses = [ "172.16.88.11/24" ];
}
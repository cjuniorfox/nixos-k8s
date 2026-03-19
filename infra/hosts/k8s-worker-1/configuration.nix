{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
      ../../modules/kubernetes/worker.nix
      ../../networking.nix
      ../../storage.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "k8s-worker-1";

}
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


  users = { 
    users.junior = {
      isNormalUser = true;
      uid = 1000;
      description = "Junior";
      extraGroups = ["users"  "wheel"];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK09EnVr2gDa3dTbMJef2jh2gVXgeOo3FPfR6+0ecOUp" ];
    };
  };

  system.stateVersion = "25.11";

}
{ config, pkgs, ... }:

{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
    git
    kubectl
    wget
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  security.pki.certificateFiles = [
    ./certs/cloudstrife-ca.crt
  ];

  services.openssh.enable = true;
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
}
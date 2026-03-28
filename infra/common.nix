{ config, pkgs, ... }:

{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    vim
    git
    kubectl
    kubernetes-helm
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
  services.qemuGuest.enable = true;

  # Allow kubernetes write to these directories for CNI and CSI plugins
  systemd.tmpfiles.rules = [
    "d /opt/cni 0755 root root -"
    "d /var/lib/cni/net.d 0755 root root -"
    # Required by Calico CSI node driver
    "r /var/lib/kubelet/plugins_registry"
    "d /var/lib/kubelet/plugins_registry 0755 root root -"
    "d /var/lib/kubelet/plugins/ 0755 root root -"
  ];

  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.11";

  users = { 
    users.junior = {
      isNormalUser = true;
      uid = 1000;
      description = "Junior";
      extraGroups = ["users"  "wheel"];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK09EnVr2gDa3dTbMJef2jh2gVXgeOo3FPfR6+0ecOUp" ];
    };
  };

}
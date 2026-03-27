{config, pkgs, ... }:
{
  networking.firewall.enable = false;

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.rp_filter" = 0;
  };
}
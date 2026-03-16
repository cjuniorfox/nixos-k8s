{config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /data/immich 0755 root root -"
    "d /data/media 0755 root root -"
    "d /data/postgres 0755 root root -"
  ];
}
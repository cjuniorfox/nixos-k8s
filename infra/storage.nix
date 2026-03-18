{config, pkgs, ... }:
{
  users.groups.media = {};

  systemd.tmpfiles.rules = [
    "d /data/immich 0755 root root -"
    "d /data/media 0775 root media -"
    "d /data/media/library 0775 root media -"
    "d /data/jellyfin 0755 root root -"
    "d /data/jellyfin/config 0775 root media -"
    "d /data/jellyfin/cache 0775 root media -"
    "d /data/postgres 0755 root root -"
  ];
}
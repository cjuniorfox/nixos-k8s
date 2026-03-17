{ config, pkgs, ... }:

{
  services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    # Dual stack cluster networks
    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiserver.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    # Disable flannel so we can install Calico manually
    flannel.enable = false;

    addonManager.enable = true;

    apiserver.allowPrivileged = true;
    kubelet = {
      cni = {
        packages = [ pkgs.cni-plugins ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    6443
    2379
    2380
    10250
    10257
    10259
    179
  ];

  system.activationScripts.calico-cni = ''
    mkdir -p /opt/cni/bin

    # extract calico binaries from image if not present
    if [ ! -f /opt/cni/bin/calico ]; then
      echo "Installing Calico CNI binaries..."

      TMP=$(mktemp -d)

      ${pkgs.skopeo}/bin/skopeo copy \
        docker://docker.io/calico/cni:v3.25.0 \
        dir:$TMP

      tar -xzf $TMP/*/layer.tar -C $TMP

      cp $TMP/opt/cni/bin/calico* /opt/cni/bin/

      chmod +x /opt/cni/bin/calico*
      rm -rf $TMP
  fi
'';
}
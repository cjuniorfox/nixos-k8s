{ config, pkgs, ... }:
  {
    services.kubernetes = {
    roles = [ "master" ];
    masterAddress = "k8s-control.vms.lan";
    easyCerts = true;

    clusterCidr = "10.244.0.0/16,fd00:10:244::/56";
    apiserver.serviceClusterIpRange = "10.96.0.0/12,fd00:10:96::/108";

    # Install Calico instead of Flannel for networking
    flannel.enable = false;
    # Calico is the default CNI plugin in Kubernetes 1.24 and later, so we don't need to explicitly enable it.
    # kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

    addonManager.enable = true;

    apiserver.extraOpts =
      "--enable-admission-plugins=PodSecurity \
       --admission-control-config-file=/etc/kubernetes/pod-security.yaml";
  };

  environment.etc."kubernetes/pod-security.yaml".text = ''
  apiVersion: pod-security.admission.config.k8s.io/v1
  kind: PodSecurityConfiguration
  defaults:
    enforce: "baseline"
    enforce-version: "latest"
    warn: "baseline"
    warn-version: "latest"
    audit: "baseline"
    audit-version: "latest"
  exemptions:
    namespaces:
      - kube-system
  '';

  networking.firewall.allowedTCPPorts = [
    22
    6443
    2379
    2380
    10250
    10257
    10259
  ];
}
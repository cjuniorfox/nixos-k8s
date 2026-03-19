{
  description = "Homelab Kubernetes cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      k8s-control = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/k8s-control/configuration.nix
        ];
      };
    };
    nixosConfigurations."k8s-worker-1" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/k8s-worker-1/configuration.nix
      ];
    };
  };
}
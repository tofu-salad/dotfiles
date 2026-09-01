{
  description = "tofu salad nix flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    emby-flake.url = "github:tofu-salad/emby-server-flake";
  };

  outputs =
    {
      emby-flake,
      nixpkgs,
      self,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      mkHost =
        modules:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          inherit modules;
        };
    in
    {
      overlays = import ./overlays { inherit inputs; };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      nixosConfigurations = {
        desktop = mkHost [
          ./modules
          ./hosts/desktop
        ];
        homelab = mkHost [
          ./hosts/homelab
          emby-flake.nixosModules.default
        ];
        laptop = mkHost [
          ./modules
          ./hosts/laptop
        ];
        vm = mkHost [
          ./modules
          ./hosts/vm
        ];
      };
    };
}

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
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      emby-flake,
      home-manager,
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
      overlays = import ./nix/overlays { inherit inputs; };
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      nixosConfigurations = {
        desktop = mkHost [
          home-manager.nixosModules.home-manager
          ./nix/home
          ./nix/hosts/common.nix
          ./nix/modules
          ./nix/hosts/desktop
        ];
        homelab = mkHost [
          ./nix/hosts/common.nix
          ./nix/hosts/homelab
          emby-flake.nixosModules.default
        ];
        laptop = mkHost [
          home-manager.nixosModules.home-manager
          ./nix/home
          ./nix/hosts/common.nix
          ./nix/modules
          ./nix/hosts/laptop
        ];
        vm = mkHost [
          home-manager.nixosModules.home-manager
          ./nix/home
          ./nix/hosts/common.nix
          ./nix/hosts/vm
        ];
      };
      homeConfigurations.tofu = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./nix/home/tofu
        ];
      };
    };
}

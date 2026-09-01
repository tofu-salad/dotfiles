# tofusalad nix config

## usage:
1. clone the repo.
2. replace the `hardware-configuration.nix` inside `hosts/<host>/hardware-configuration.nix` with correct one.
```Makefile
Available commands:
  make desktop             - Rebuild system for desktop
  make homelab             - Rebuild system for homelab
  make laptop              - Rebuild system for laptop

  make update/all          - Update all inputs
  make update/emby-flake   - Update emby flake
  make update/stable       - Update nixpkgs
  make update/unstable     - Update nixpkgs-unstable

  make format  	           - Format nix files using nixfmt-rfc-style and nixfmt-tree (can be accessed with nix develop)
```

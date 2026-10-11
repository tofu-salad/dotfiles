# tofusalad nix dotfiles

NixOS system config + home-manager user config, managed as a flake.

## structure

```
flake.nix                  # flake entry point (system + home)
nix/
  home/
    default.nix            # NixOS wiring for home-manager
    homelab.nix            # slim home-manager wiring for the homelab
    tofu/default.nix       # portable user config (works standalone)
  hosts/
    common.nix             # shared NixOS plumbing (time, locale, nix, networking, overlays)
    desktop/               # niri+tiling WM system
    laptop/                # KDE system
    vm/                    # i3 VM
    homelab/               # headless server (home-manager + fish)
  modules/                 # optional system modules (desktop, display, gaming, workstation...)
  overlays/                # unstable-packages overlay
dotfiles/                  # home configs symlinked by home-manager
```

## usage

1. clone the repo.
2. rebuild — each `make <host>` regenerates the machine's `hardware-configuration.nix`
   via `nixos-generate-config --show-hardware-config` (gitignored) before rebuilding:

```sh
cd ~/dotfiles
make desktop    # or: make laptop / make vm / make homelab
```

`make homelab` includes home-manager too — it applies the slim `nix/home/homelab.nix`
profile (fish + CLI tools) alongside the system config.

## home-manager

`nix/home/tofu/default.nix` is the desktop user config: packages, fish/direnv, and
symlinks into `dotfiles/` via `mkOutOfStoreSymlink` (edit files, no rebuild
needed). Applied automatically on desktop/laptop/vm rebuilds. It is portable
and can be used outside NixOS (any distro with Nix + flakes):

```sh
home-manager switch --flake .#tofu
# or
make home
```

## commands

```
make help                - Show available commands
make home                - Apply home-manager config (tofu)
make desktop             - Rebuild system for desktop
make homelab             - Rebuild system for homelab
make laptop              - Rebuild system for laptop
make vm                  - Rebuild system for vm

make update/all          - Update all inputs
make update/emby-flake   - Update emby flake
make update/stable       - Update nixpkgs
make update/unstable     - Update nixpkgs-unstable

make format              - Format nix files (uses formatter from flake)
```
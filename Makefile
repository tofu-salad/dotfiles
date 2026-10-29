.DEFAULT_GOAL := help

.PHONY: help home laptop desktop homelab vm \
        update/stable update/unstable \
        update/all \
        format

help:
	@echo "Available commands:"
	@echo "  make home                - Build home-manager setup (tofu)"
	@echo "  make desktop             - Rebuild system for desktop"
	@echo "  make homelab             - Rebuild system for homelab"
	@echo "  make laptop              - Rebuild system for laptop"
	@echo "  make vm                  - Rebuild system for vm"
	@echo
	@echo "  make update/all          - Update all inputs"
	@echo "  make update/stable       - Update nixpkgs"
	@echo "  make update/unstable     - Update nixpkgs-unstable"
	@echo
	@echo "  make format  	           - Format nix files"
format:
	find . -name '*.nix' -not -path './.git/*' -exec nix fmt {} +
# home
home:
	home-manager switch --flake .#tofu
# hosts
# regenerate the machine's hardware-configuration.nix, then rebuild
laptop:
	nixos-generate-config --show-hardware-config > nix/hosts/laptop/hardware-configuration.nix
	sudo nixos-rebuild switch --flake .#laptop

desktop:
	nixos-generate-config --show-hardware-config > nix/hosts/desktop/hardware-configuration.nix
	sudo nixos-rebuild switch --flake .#desktop

homelab:
	nixos-generate-config --show-hardware-config > nix/hosts/homelab/hardware-configuration.nix
	sudo nixos-rebuild switch --flake .#homelab

vm:
	nixos-generate-config --show-hardware-config > nix/hosts/vm/hardware-configuration.nix
	sudo nixos-rebuild switch --flake .#vm

# updates
update/stable:
	nix flake update nixpkgs

update/unstable:
	nix flake update nixpkgs-unstable

update/all:
	nix flake update

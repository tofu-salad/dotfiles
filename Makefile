.DEFAULT_GOAL := help

.PHONY: help home laptop desktop homelab vm \
        update/stable update/unstable \
        update/emby-flake update/all \
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
	@echo "  make update/emby-flake   - Update emby flake"
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
laptop:
	sudo nixos-rebuild switch --flake .#laptop

desktop:
	sudo nixos-rebuild switch --flake .#desktop

homelab:
	sudo nixos-rebuild switch --flake .#homelab
vm:
	sudo nixos-rebuild switch --flake .#vm

# updates
update/stable:
	nix flake update nixpkgs

update/unstable:
	nix flake update nixpkgs-unstable

update/emby-flake:
	nix flake update emby-flake

update/all:
	nix flake update

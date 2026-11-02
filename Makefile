SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

HOSTS := laptop desktop homelab vm

.PHONY: help home format update/all update/stable update/unstable \
        $(HOSTS) $(addprefix hw/,$(HOSTS)) $(addprefix new/,$(HOSTS))

help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_/-]+:.*## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  make %-22s %s\n", $$1, $$2}'
	@printf "  make %-22s %s\n" "<host>" "Rebuild system ($(HOSTS))"
	@printf "  make %-22s %s\n" "hw/<host>" "Regenerate hardware-configuration.nix"
	@printf "  make %-22s %s\n" "new/<host>" "Fresh install: hw/<host> then rebuild"

format: ## Format nix files
	find . -name '*.nix' -not -path './.git/*' -exec nix fmt {} +

home: ## Build home-manager setup (tofu)
	home-manager switch --flake .#tofu

# Regular rebuild
$(HOSTS): %:
	sudo nixos-rebuild switch --flake .#$*

# Regenerate hardware config (run on the target machine).
# Writes to a temp file first so a failed generate can't leave an empty file.
$(addprefix hw/,$(HOSTS)): hw/%:
	@set -e; tmp=$$(mktemp); trap 'rm -f $$tmp' EXIT; \
	sudo nixos-generate-config --show-hardware-config > $$tmp; \
	cat $$tmp > nix/hosts/$*/hardware-configuration.nix
	nix fmt nix/hosts/$*/hardware-configuration.nix

# Fresh install on a new machine
$(addprefix new/,$(HOSTS)): new/%: hw/%
	$(MAKE) $*

update/all: ## Update all inputs
	nix flake update

update/stable: ## Update nixpkgs
	nix flake update nixpkgs

update/unstable: ## Update nixpkgs-unstable
	nix flake update nixpkgs-unstable

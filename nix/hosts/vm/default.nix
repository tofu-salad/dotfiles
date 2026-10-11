{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  desktop.hyprland.enable = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "vm";
  hardware.graphics.enable = true;

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  virtualisation.virtualbox.guest.enable = true;
  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "26.05";
}

{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # environment.sessionVariables = rec {
  #       WLR_NO_HARDWARE_CURSORS = 1;
  # };
  desktop.hyprland.enable = true;
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "vm";

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "vboxsf"
    ];
  };

  virtualisation.virtualbox.guest.enable = true;
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    firefox
  ];

  system.stateVersion = "26.05";
}

{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  desktop.kde.enable = true;

  i18n.defaultLocale = lib.mkForce "es_ES.UTF-8";
  networking.hostName = "laptop";

  # windows fonts
  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

  environment.sessionVariables = {
    GSK_RENDERER = "gl";
    LIBVA_DRIVER_NAME = "i965";
  };

  environment.systemPackages = with pkgs; [
    # gui
    libreoffice
  ];

  boot = {
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
    ];
    loader.timeout = 0;
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
  ];
  hardware.bluetooth.enable = true;

  virt = {
    enable = true;
    virt-manager.enable = true;
  };

  system.stateVersion = "26.05";
}

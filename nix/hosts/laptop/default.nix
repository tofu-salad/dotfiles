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

  users.users.tofu = {
    isNormalUser = true;
    description = "laptop";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  i18n.defaultLocale = lib.mkForce "es_ES.UTF-8";
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
  };

  # windows fonts
  fonts.packages = with pkgs; [
    corefonts
    vista-fonts
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GSK_RENDERER = "gl";
    LIBVA_DRIVER_NAME = "i965";
  };

  environment.systemPackages = with pkgs; [
    # browsers
    google-chrome
    unstable.brave-origin
    stremio-linux-shell

    # media
    localsend
    mpv

    # gui
    libreoffice
    qbittorrent
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
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;

  zramSwap.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };
  hardware.bluetooth.enable = true;

  virt = {
    enable = true;
    virt-manager.enable = true;
  };

  system.stateVersion = "26.05";
}

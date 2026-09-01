{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  desktop.niri.enable = true;
  screenCastOBS.enable = true;
  virt = {
    enable = true;
    virt-manager.enable = true;
  };

  users.users.tofu = {
    isNormalUser = true;
    description = "tofu salad nixos config";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    gimp
    localsend
    mpv
    qbittorrent
    stremio-linux-shell

    # browsers
    google-chrome
    unstable.brave-origin

    # libs
    cifs-utils
    openssl
  ];

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;
  zramSwap.enable = true;
  hardware.graphics.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    timeout = 1;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.05";
}

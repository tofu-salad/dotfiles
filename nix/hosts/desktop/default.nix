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

  networking.hostName = "desktop";

  environment.systemPackages = with pkgs; [
    gimp

    # libs
    cifs-utils
    openssl
  ];

  boot.loader.timeout = 1;

  system.stateVersion = "26.05";
}

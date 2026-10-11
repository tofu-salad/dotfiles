{ lib, pkgs, ... }:
with lib;
{
  users.users.tofu = {
    isNormalUser = true;
    description = mkDefault "tofu salad nixos config";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fileSystems."/".options = [ "noatime" ];
  services.fstrim.enable = true;

  zramSwap.enable = true;

  hardware.graphics.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    efi.canTouchEfiVariables = true;
  };

  services.tailscale.enable = true;
  services.avahi.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # browsers
    google-chrome
    unstable.brave-origin
    stremio-linux-shell

    # media
    localsend
    mpv
    qbittorrent
  ];
}

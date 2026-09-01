{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraPackages = [ ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = "autologin-user=tofu";

  environment.pathsToLink = [ "/libexec" ];

  boot.loader.timeout = 0;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "vm";
  networking.networkmanager.enable = true;
  users.users.tofu = {
    isNormalUser = true;
    description = "tofu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "autologin"
    ];
  };
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty
    mako
    xclip
  ];

  system.stateVersion = "26.05";
}

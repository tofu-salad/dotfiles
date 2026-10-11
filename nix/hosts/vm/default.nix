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

  # autologin straight into Hyprland (skip the greeter)
  services.greetd.settings.default_session = {
    user = lib.mkForce "tofu";
    command = ''
      ${pkgs.bash}/bin/bash -lc "exec ${pkgs.dbus}/bin/dbus-run-session -- ${pkgs.hyprland}/bin/Hyprland"
    '';
  };

  environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  boot.loader = {
    timeout = 0;
    grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
    };
  };

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

  environment.pathsToLink = [ "/libexec" ];
  environment.systemPackages = with pkgs; [
    mako
  ];

  system.stateVersion = "26.05";
}

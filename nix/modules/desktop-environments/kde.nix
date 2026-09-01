{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.kde;
in
{
  options.desktop.kde.enable = mkEnableOption "KDE";
  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      discover
      elisa
      khelpcenter
      konsole
      plasma-browser-integration
    ];

    environment.systemPackages = with pkgs; [
      kitty
      wl-clipboard
    ];
  };
}

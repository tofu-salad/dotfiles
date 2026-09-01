{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.hyprland;
in
{
  options.desktop.hyprland.enable = mkEnableOption "Hyprland";

  config = mkIf cfg.enable {
    desktop.tilingWmBase.enable = true;
    programs.hyprland = {
      withUWSM = true;
      enable = true;
    };
    xdg = {
      portal = {
        enable = true;
        config = {
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          };
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      };
    };
  };
}

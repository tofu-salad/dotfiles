{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.sway;
in
{
  options.desktop.sway.enable = mkEnableOption "Sway";
  config = mkIf cfg.enable {
    desktop.tilingWmBase = {
      enable = true;
      portal.wlr.enable = true;
    };

    programs = {
      uwsm.enable = true;

      uwsm.waylandCompositors.sway = {
        prettyName = "Sway";
        binPath = "/run/current-system/sw/bin/sway";
      };

      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          brightnessctl
        ];
      };
    };
  };
}

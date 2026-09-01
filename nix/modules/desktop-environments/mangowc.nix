{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.desktop.mangowc;
in
{
  options.desktop.mangowc.enable = mkEnableOption "MangoWC";
  config = mkIf cfg.enable {
    desktop.tilingWmBase = {
      enable = true;
      portal.wlr.enable = true;
    };

    programs.mangowc.enable = true;
    programs = {
      uwsm.enable = true;
      uwsm.waylandCompositors.mangowc = {
        prettyName = "MangoWC";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };
  };
}

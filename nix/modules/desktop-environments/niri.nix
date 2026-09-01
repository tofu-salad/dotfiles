{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.niri;
in
{
  options.desktop.niri.enable = mkEnableOption "Niri";
  config = mkIf cfg.enable {
    desktop.tilingWmBase.enable = true;
    programs.niri.enable = true;
    programs.dms-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}

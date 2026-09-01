{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.standaloneGnomeSuite;
in
{
  imports = [ ./standalone-base.nix ];
  options.desktop.standaloneGnomeSuite = {
    enable = mkEnableOption "standalone gnome application + gtk plumbing";

    enableLocalsearch = mkOption {
      type = types.bool;
      default = true;
      description = "enable gnome tracker / localsearch";
    };
  };
  config = mkIf cfg.enable {
    desktop.standaloneBase.enable = true;

    environment.systemPackages = with pkgs; [
      nautilus
      baobab
      file-roller
      loupe
      papers

      gnome-calculator
      gnome-characters
      gnome-font-viewer
      gnome-text-editor
      gnome-disk-utility
      libsForQt5.qt5ct

      adwaita-qt
      adwaita-qt6
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

    services.gnome.localsearch.enable = cfg.enableLocalsearch;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

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
    display.manager = "greetd";
    programs.hyprland.enable = true;

    security.polkit.enable = true;

    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
    services.gnome.gnome-keyring.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.gnome.localsearch.enable = true;

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };

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

    environment.systemPackages = with pkgs; [
      foot
      pwvucontrol
      wl-clipboard

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

      grim
      hyprpicker
      satty
      slurp
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.adwaita-mono
      adwaita-fonts
    ];
  };
}

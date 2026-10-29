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
    display.manager = "sddm";
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    environment.systemPackages = with pkgs; [
      foot

      mako
      waybar
      rofi
      libnotify

      swayidle
      swaylock
    ];

    systemd.user.services.swaybg = {
      description = "wallpaper";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '%h/Pictures/wallpapers/minu-phone.png'";
        Restart = "on-failure";
      };
    };

    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    systemd.user.services.swayidle = {
      description = "swayidle";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 300 '${pkgs.swaylock}/bin/swaylock -f' timeout 600 'hyprctl dispatch dmps off' resume 'hyprctl dispatch dmps on' before-sleep '${pkgs.swaylock}/bin/swaylock -f'";
        Restart = "on-failure";
      };
    };

    fonts.packages = with pkgs; [
      adwaita-fonts
    ];
  };
}

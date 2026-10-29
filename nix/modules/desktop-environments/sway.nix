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
    display.manager = "sddm";
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    environment.systemPackages = with pkgs; [
      mako
      rofi
      waybar
      swaybg
    ];

    systemd.user.services.swaybg = {
      description = "hyprpaper";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i '%h/Pictures/wallpapers/minu-phone.png'";
        Restart = "on-failure";
      };
    };
    fonts.packages = with pkgs; [
      adwaita-fonts
    ];
  };
}

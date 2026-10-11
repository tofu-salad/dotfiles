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
      kitty

      hyprpaper
      hyprlauncher
      mako
      hyprpolkitagent
      waybar
    ];

    systemd.user.services.mako = {
      description = "mako notification daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
      };
    };
    systemd.user.services.hyprpaper = {
      description = "hyprpaper";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "on-failure";
      };
    };
    fonts.packages = with pkgs; [
      nerd-fonts.adwaita-mono
      adwaita-fonts
    ];
  };
}

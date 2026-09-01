{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "gaming (Steam, Wine, MangoHud, Gamescope, GameMode)";
    lutris.enable = mkEnableOption "Lutris";
    heroic.enable = mkEnableOption "Heroic Games Launcher";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
          adwaita-icon-theme
          adwaita-icon-theme-legacy
        ];
      };
      programs.gamescope.enable = true;
      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
        wineWow64Packages.stable
        winetricks
      ];
    })
    (mkIf cfg.lutris.enable {
      environment.systemPackages = with pkgs; [ lutris ];
    })
    (mkIf cfg.heroic.enable {
      environment.systemPackages = with pkgs; [ heroic ];
    })
  ];
}

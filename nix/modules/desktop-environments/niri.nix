{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.niri;
in
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];
  options.desktop.niri.enable = mkEnableOption "Niri";
  config = mkIf cfg.enable {

    desktop.tilingWmBase.enable = true;
    programs.niri.enable = true;
    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}

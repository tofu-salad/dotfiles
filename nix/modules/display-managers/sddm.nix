{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.display.sddm;
in
{
  options.display.sddm = {
    theme = mkOption {
      type = types.str;
      default = "where_is_my_sddm_theme";
    };

    themePackage = mkOption {
      type = types.package;
      default = pkgs.where-is-my-sddm-theme;
      description = "package providing the sddm theme";
    };

    wayland.enable = mkOption {
      type = types.bool;
      default = true;
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ pkgs.kdePackages.qt5compat ];
    };
  };

  config = mkIf (config.display.manager == "sddm") {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = cfg.wayland.enable;
      theme = cfg.theme;
      extraPackages = cfg.extraPackages ++ [ cfg.themePackage ];
    };

    environment.systemPackages = [ cfg.themePackage ];
  };
}

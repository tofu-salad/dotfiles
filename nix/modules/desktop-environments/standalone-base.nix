{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.desktop.standaloneBase;
in
{
  options.desktop.standaloneBase.enable = mkEnableOption "shared standalone desktop app plumbing (dconf dark mode, keyring, gvfs, udisks2)";

  config = mkIf cfg.enable {
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
  };
}

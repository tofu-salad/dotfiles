{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.display.greetd;
in
{
  options.display.greetd = {
    enable = mkEnableOption "greetd display manager";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.tuigreet}/bin/tuigreet \
            --time --remember --remember-session \
            --sessions /run/current-system/sw/share/wayland-sessions
          '';
        };
      };
    };
  };
}

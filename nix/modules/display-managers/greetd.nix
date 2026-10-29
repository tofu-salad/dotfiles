{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf (config.display.manager == "greetd") {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = mkDefault ''
            ${pkgs.tuigreet}/bin/tuigreet \
            --time --remember --remember-session
          '';
        };
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.screenCastOBS.enable = mkEnableOption "screencasting with OBS + nginx RTMP";
  config = mkIf config.screenCastOBS.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
    services.nginx = {
      enable = true;
      additionalModules = [ pkgs.nginxModules.rtmp ];
      appendConfig = ''
        rtmp {
          server {
            listen 1935;
            chunk_size 4096;

            application feed {
              live on;
              record off;
            }
          }
        }
      '';
    };
    # Don't auto-start nginx; it's only meant to run while actively
    # streaming to the RTMP "feed" application (OBS), not as a daemon.
    systemd.services.nginx.wantedBy = lib.mkForce [ ];
    programs.obs-studio = {
      enable = true;
    };
  };
}

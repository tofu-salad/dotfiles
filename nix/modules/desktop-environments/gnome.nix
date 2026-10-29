{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = mkEnableOption "Gnome Desktop";
    online-accounts = mkOption {
      type = types.bool;
      default = false;
      description = "enable gnome online account sync daemon";
    };
    extensions = {
      enable = mkEnableOption "GNOME Shell extensions";
      packages = mkOption {
        type = with types; listOf package;
        default = with pkgs.gnomeExtensions; [
          dash-to-dock
          appindicator
        ];
        description = "list of gnome shell extensions to install";
      };
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.gnome-online-accounts.enable = cfg.online-accounts;
    services.gnome.core-apps.enable = true;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    services.gnome.gcr-ssh-agent.enable = false;
    programs.ssh.startAgent = true;

    environment.gnome.excludePackages = with pkgs; [
      showtime
      decibels
      epiphany
      evince
      geary
      gnome-connections
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-software
      gnome-tour
      gnome-user-docs
      snapshot
      totem
    ];

    environment.systemPackages = (if cfg.extensions.enable then cfg.extensions.packages else [ ]) ++ [
      pkgs.ghostty
      pkgs.wl-clipboard
    ];

    services.udev.packages = [ pkgs.gnome-settings-daemon ];
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = mkMerge [
          {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };

            "org/gnome/desktop/wm/keybindings" = {
              close = lib.gvariant.mkArray [ "<Super>q" ];
              switch-to-workspace-1 = lib.gvariant.mkArray [ "<Super>1" ];
              switch-to-workspace-2 = lib.gvariant.mkArray [ "<Super>2" ];
              switch-to-workspace-3 = lib.gvariant.mkArray [ "<Super>3" ];
              switch-to-workspace-4 = lib.gvariant.mkArray [ "<Super>4" ];
              switch-to-workspace-5 = lib.gvariant.mkArray [ "<Super>5" ];
              switch-to-workspace-6 = lib.gvariant.mkArray [ "<Super>6" ];
              switch-to-workspace-7 = lib.gvariant.mkArray [ "<Super>7" ];
              switch-to-workspace-8 = lib.gvariant.mkArray [ "<Super>8" ];
              switch-to-workspace-9 = lib.gvariant.mkArray [ "<Super>9" ];

              move-to-workspace-1 = lib.gvariant.mkArray [ "<Super><Shift>1" ];
              move-to-workspace-2 = lib.gvariant.mkArray [ "<Super><Shift>2" ];
              move-to-workspace-3 = lib.gvariant.mkArray [ "<Super><Shift>3" ];
              move-to-workspace-4 = lib.gvariant.mkArray [ "<Super><Shift>4" ];
              move-to-workspace-5 = lib.gvariant.mkArray [ "<Super><Shift>5" ];
              move-to-workspace-6 = lib.gvariant.mkArray [ "<Super><Shift>6" ];
              move-to-workspace-7 = lib.gvariant.mkArray [ "<Super><Shift>7" ];
              move-to-workspace-8 = lib.gvariant.mkArray [ "<Super><Shift>8" ];
              move-to-workspace-9 = lib.gvariant.mkArray [ "<Super><Shift>9" ];
            };

            "org/gnome/shell/keybindings" = {
              switch-to-application-1 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-2 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-3 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-4 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-5 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-6 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-7 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-8 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
              switch-to-application-9 = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
            };

            "org/gnome/desktop/input-sources".xkb-options = lib.gvariant.mkArray [
              "terminate:ctrl_alt_bksp"
              "caps:escape"
            ];

            "org/gnome/mutter".overlay-key = "";

            "org/gnome/settings-daemon/plugins/media-keys" = {
              search = lib.gvariant.mkArray [ "<Super>d" ];
              www = lib.gvariant.mkArray [ "<Super>w" ];
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              binding = "<Super>Return";
              command = "${pkgs.ghostty}/bin/ghostty +new-window";
              name = "ghostty";
            };
          }

          (mkIf cfg.extensions.enable {
            "org/gnome/shell" = {
              enabled-extensions = map (ext: ext.extensionUuid) cfg.extensions.packages;
            };
          })
        ];
      }
    ];
  };
}

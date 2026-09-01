{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.desktop.tilingWmBase;
  adwaitaCursorTheme = pkgs.runCommandLocal "adwaita-cursor-default-theme" { } ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.adwaita-icon-theme}/share/icons/Adwaita $out/share/icons/default
  '';
  screenCastChooser = "${pkgs.fuzzel}/bin/fuzzel --dmenu --minimal-lines --hide-prompt --font 'Adwaita Mono:size=16' --no-exit-on-keyboard-focus-loss";

  # Helper to build a simple graphical-session user service.
  mkGraphicalSessionService = name: { description, execStart }: {
    enable = true;
    inherit description;

    unitConfig = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };

    serviceConfig = {
      ExecStart = execStart;
      Restart = "on-failure";
    };

    wantedBy = [ "graphical-session.target" ];
  };
in
{
  options.desktop.tilingWmBase = {
    enable = mkEnableOption "Shared tiling WM base configuration";

    screenshot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable screenshot tools for tiling WMs";
    };

    portal.wlr.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the xdg-desktop-portal-wlr backend (for wlroots compositors)";
    };
  };

  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.standaloneGnomeSuite.enable = true;

    security.polkit.enable = true;

    environment.systemPackages =
      with pkgs;
      [
        adwaitaCursorTheme
        fuzzel
        kitty
        mako
        libnotify
        pwvucontrol
        swayidle
        swaylock
        waybar

        wl-clip-persist
        wl-clipboard
        xclip
      ]
      ++ optionals cfg.screenshot.enable [
        grim
        hyprpicker
        satty
        slurp
      ];

    fonts.packages = with pkgs; [
      nerd-fonts.adwaita-mono
    ];

    # XDG Desktop Portals
    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = cfg.portal.wlr.enable;
          settings.screencast = {
            chooser_type = "dmenu";
            chooser_cmd = screenCastChooser;
          };
        };
      };
    };

    # services
    systemd.user.services = {
      swaybg = mkGraphicalSessionService "swaybg" {
        description = "Swaybg wallpaper service";
        execStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/Wallpapers/birmingham-museums-trust-1953P60-Chinese-Scene-With-Figures-Playing.jpg";
      };

      wl-clip-persist = mkGraphicalSessionService "wl-clip-persist" {
        description = "Persist Wayland clipboard";
        execStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
      };
    };
  };
}

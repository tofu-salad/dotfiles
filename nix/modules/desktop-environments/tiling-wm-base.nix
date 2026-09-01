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
  };

  config = mkIf cfg.enable {
    display.greetd.enable = true;
    desktop.standaloneGnomeSuite.enable = true;

    security.polkit.enable = true;

    environment.systemPackages =
      with pkgs;
      [
        adwaitaCursorTheme
        foot
        libnotify
        pwvucontrol
        wl-clip-persist
        wl-clipboard
      ]
      ++ optionals cfg.screenshot.enable [
        grim
        hyprpicker
        satty
        slurp
      ];

    fonts.packages = with pkgs; [
      nerd-fonts.adwaita-mono
      adwaita-fonts
    ];

    # services
    systemd.user.services = {
      wl-clip-persist = mkGraphicalSessionService "wl-clip-persist" {
        description = "Persist Wayland clipboard";
        execStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
      };
    };
  };
}

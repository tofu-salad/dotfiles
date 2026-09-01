{
  config,
  lib,
  ...
}:
let
  enabledDesktops = lib.filter (name: config.desktop.${name}.enable) [
    "gnome"
    "kde"
    "hyprland"
    "niri"
    "sway"
    "mangowc"
  ];
in
{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
    ./niri.nix
    ./standalone-gnome-suite.nix
    ./sway.nix
    ./tiling-wm-base.nix
    ./standalone-kde-suite.nix
    ./mangowc.nix
  ];

  assertions = [
    {
      assertion = lib.length enabledDesktops <= 1;
      message = ''
        Multiple desktops enabled: ${lib.concatStringsSep ", " enabledDesktops}.
        Only one of gnome/kde/hyprland/niri/sway/mangowc may be enabled.
      '';
    }
  ];
}

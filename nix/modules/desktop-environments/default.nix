{
  config,
  lib,
  ...
}:
let
  enabledDesktops = lib.filter (name: config.desktop.${name}.enable) [
    "gnome"
    "kde"
    "niri"
  ];
in
{
  imports = [
    ./gnome.nix
    ./kde.nix
    ./niri.nix
    ./standalone-gnome-suite.nix
    ./tiling-wm-base.nix
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

{
  config,
  inputs,
  lib,
  ...
}:
let
  enabledDesktops = lib.filter (name: config.desktop.${name}.enable) [
    "gnome"
    "kde"
    "hyprland"
    "niri"
  ];
in
{
  imports = [
    inputs.noctalia.nixosModules.default
    ./gnome.nix
    ./kde.nix
    ./hyprland.nix
    ./niri.nix
  ];

  assertions = [
    {
      assertion = lib.length enabledDesktops <= 1;
      message = ''
        Multiple desktops enabled: ${lib.concatStringsSep ", " enabledDesktops}.
        Only one of gnome/kde/hyprland/niri may be enabled.
      '';
    }
  ];
}

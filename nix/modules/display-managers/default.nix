{
  lib,
  ...
}:
with lib;
{
  imports = [
    ./greetd.nix
    ./sddm.nix
  ];

  options.display.manager = mkOption {
    type = types.nullOr (
      types.enum [
        "greetd"
        "sddm"
      ]
    );
    default = null;
    description = "Standalone display manager to use (GNOME always uses GDM)";
  };
}

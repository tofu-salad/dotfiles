{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  inherit (inputs.nix-minecraft.lib) collectFilesAt;
  # ============================================================
  # MODPACKS
  # ============================================================

  modpack26 = pkgs.fetchModrinthModpack {
    url = "https://cdn.modrinth.com/data/1ocGzRHv/versions/Bu8RKHri/Vanilla%20Perfected%201.0.0%2B26.3.mrpack";
    packHash = "sha256-CQl8cIgmdKtdoF9BptV8H7aBzpyuJhn/rRtcL8UoX2c=";
    side = "server";
  };

  modpack121 = pkgs.fetchModrinthModpack {
    url = "https://cdn.modrinth.com/data/1ocGzRHv/versions/PXpjyGBU/Vanilla%20Perfected%201.0.3.mrpack";
    packHash = "sha256-hAhDiUyDFR8eVAvUdbnw7DjMnBfGLIUN2fvTL4l7Tz4=";
    side = "server";
  };

  # ============================================================
  # 26.2
  # ============================================================

  mods26 = pkgs.symlinkJoin {
    name = "mods26";

    paths = [
      # Modpack
      "${modpack26}/mods"

      # Individual mods
      (pkgs.linkFarmFromDrvs "mods26-extra" (
        builtins.attrValues {

          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/UWwhUX3k/fabric-api-0.160.0%2B26.2.jar";
            hash = "sha256-Xz3/iOFmEWbiIiEzArJazmw23DaDgEy9S1rPkxOOoF4=";
          };

          Biome-o-Plenty = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/HXF82T3G/versions/Wh39Z5IZ/BiomesOPlenty-fabric-26.2-26.1.2.0.40.jar";
            hash = "sha256-fTHUozl2z2vrKsF4o83EEv0zQmHZGFRbtbgl/kEsIg4=";
          };

          Xaero-Minimap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1bokaNcj/versions/W7vHFz3T/xaerominimap-fabric-26.2-26.4.2.jar";
            hash = "sha256-aShIktLrhTya76haTJt0IywyLaACB5lMZ6uK7timQEg=";
          };

          Xaero-World-Map = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/NcUtCpym/versions/Z6wZaeAX/xaeroworldmap-fabric-26.2-1.45.0.jar";
            hash = "sha256-kvlxkSHg590MKGcg+YevLvguzoeGxVynD0CmzwIHYmc=";
          };

          Better-Combat = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/5sy6g3kz/versions/enlZuzkJ/bettercombat-fabric-3.2.2%2B26.2.jar";
            hash = "sha256-zOgnmS9RexgbwlxPbDXix1gY0p/NvqkMODhwQ2SwRjk=";
          };

          Just-Enough-Items = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/d3HeviSL/jei-26.2-fabric-30.29.0.201.jar";
            hash = "sha256-WTdyhnQey91rLvDk5/MV+ZTDsKjbn5UI/PYt9MBi3X4=";
          };
        }
      ))
    ];
  };

  # ============================================================
  # 1.21
  # ============================================================

  mods121 = pkgs.symlinkJoin {
    name = "mods121";

    paths = [
      # Modpack
      "${modpack121}/mods"

      # Individual mods
      (pkgs.linkFarmFromDrvs "mods121-extra" (
        builtins.attrValues {

          Fabric-API = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/oGwyXeEI/fabric-api-0.102.0%2B1.21.jar";
            hash = "sha256-fsDloR53lX/h7QMoSHkhqCEbt+rOFCmM10Y1vsYaPyY=";
          };
          Xaero-World-Map = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/NcUtCpym/versions/yz0BNgrU/XaerosWorldMap_1.40.2_Fabric_1.21.jar";
            version = "1.40.2";
            hash = "sha256-O5GL3HF+UUG1uNNyn71Yfy2GmWxzRQcmWd9rw2iNbUI=";
          };
          Xaero-Minimap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/1bokaNcj/versions/T78xsQuu/Xaeros_Minimap_25.3.2_Fabric_1.21.jar";
            version = "25.3.2";
            hash = "sha256-Qne+4O8F0encHgO1HVLGe9ZFe7V0AkB+WbFq17COg3k=";
          };
        }
      ))
    ];
  };
in
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.fabric26 = {
      enable = false;

      package = pkgs.fabricServers.fabric-26_2.override {
        jre_headless = pkgs.openjdk25_headless;
      };

      symlinks.mods = mods26;
    };

    servers.noforge = {
      enable = true;
      openFirewall = true;
      serverProperties = {
        online-mode = false;
      };
      package = pkgs.fabricServers.fabric-1_21.override {
        loaderVersion = "0.16.10";
      };

      symlinks.mods = mods121;

      files = {
        "config/xaero/lib/common.cfg" = {
          format = pkgs.formats.keyValue { };
          value = {
            default_enforced_profile = "default";
            enforced_profile_permission_node = "xaero.lib.enforced_server_profile";
            allow_internet_access = true;
            everyone_tracks_everyone = true;
            edit_server_profiles_permission_node = "xaero.lib.edit_server_profiles";
          };
        };
      };
    };
  };
}

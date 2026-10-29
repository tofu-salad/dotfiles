{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  home-manager.users.tofu =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      repoDotfiles = "${config.home.homeDirectory}/dotfiles/dots";

      configs = [
        "fish"
      ];

      files = [
        ".bashrc"
        ".bash_profile"
        ".tmux.conf"
      ];

      mkSymlink = recursive: force: name: {
        source = config.lib.file.mkOutOfStoreSymlink "${repoDotfiles}/${name}";
        inherit recursive force;
      };

      links =
        mk: names:
        builtins.listToAttrs (
          map (name: {
            name = name;
            value = mk name;
          }) names
        );
    in
    {
      home = {
        username = lib.mkDefault "tofu";
        homeDirectory = lib.mkDefault "/home/${config.home.username}";
        stateVersion = "26.05";
      };

      programs.home-manager.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      home.packages = with pkgs; [
        btop
        curl
        fd
        fish
        fzf
        gh
        git
        jq
        ripgrep
        tmux
        tree
        unzip
        wget
        nixfmt
      ];

      home.file = links (mkSymlink false false) files;

      xdg.configFile = links (mkSymlink true true) configs;
    };
}

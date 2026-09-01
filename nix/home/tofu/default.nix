{
  config,
  pkgs,
  ...
}:

let
  repoDotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";

  configs = [
    "fish"
    "foot"
    "mpv"
    "niri"
    "nvim"
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
    username = "tofu";
    homeDirectory = "/home/tofu";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    # cli
    btop
    curl
    fd
    fish
    fzf
    gh
    git
    jq
    ripgrep
    tree
    unzip
    wget

    # archives
    p7zip
    unrar

    # dev
    cargo
    gcc
    gnumake
    neovim
    nixd
    tree-sitter
    vim

    # deps
    tmux
  ];

  home.file =
    (links (mkSymlink false false) files)
    // {
      "Pictures/wallpapers" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/dotfiles/wallpapers";
        recursive = true;
      };
    };

  xdg.configFile = links (mkSymlink true true) configs;
}

{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
  ];
  programs.direnv.enable = true;
  # emby
  services.emby = {
    enable = true;
    openFirewall = true;
  };
  users.groups.media = {
    gid = 1000;
  };
  users.users.emby.extraGroups = [ "media" ];
  system.activationScripts.mediaAcl = {
    text = ''
      echo "Setting ACLs on /mnt/share ..."
      ${pkgs.acl}/bin/setfacl -R -m g:media:rwX /mnt/share
      ${pkgs.acl}/bin/setfacl -R -m d:g:media:rwX /mnt/share
    '';
  };

  # nfs
  fileSystems."/export" = {
    device = "/mnt/share";
    fsType = "none";
    options = [ "bind" ];
  };
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    exports = ''
      /export  100.64.0.0/10(rw,fsid=0,no_subtree_check,insecure,all_squash,anonuid=${toString config.users.users.tofu.uid},anongid=${toString config.users.groups.media.gid})
      /export  192.168.0.0/24(rw,fsid=0,no_subtree_check,insecure,all_squash,anonuid=${toString config.users.users.tofu.uid},anongid=${toString config.users.groups.media.gid})
    '';
  };

  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # tailscale
  services.tailscale.enable = true;
  networking.nftables.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # apps
  services = {
    audiobookshelf = {
      enable = true;
      openFirewall = true;
      port = 13378;
      host = "0.0.0.0";
    };
  };

  users.users.tofu = {
    linger = true;
    uid = 1000;

    isNormalUser = true;
    description = "tofu salad homelab config";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
    ];
  };

  networking = {
    hostName = "homelab";
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedTCPPorts = [
      80 # HTTP
      443 # HTTPS

      111 # NFS
      2049 # NFS
      4000 # NFS
      4001 # NFS
      4002 # NFS
    ];
    allowedUDPPorts = [
      config.services.tailscale.port
      111 # NFS
      2049 # NFS
      4000 # NFS
      4001 # NFS
      4002 # NFS
    ];

  };
  zramSwap.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    timeout = 0;
  };

  environment.systemPackages = with pkgs; [
    gh
    git
    gnumake
    nixfmt-tree
    tmux
    tree
    btop

    tree-sitter
    neovim
  ];

  system.stateVersion = "26.05";
}

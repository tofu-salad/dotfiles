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

  users.groups.media = {
    gid = 1000;
  };

  # media group access for the media servers
  systemd.services.media-acl = {
    description = "Set up media group access on /mnt/share";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    unitConfig.RequiresMountsFor = [ "/mnt/share" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.acl}/bin/setfacl -R -m g:media:rwX /mnt/share
      ${pkgs.findutils}/bin/find /mnt/share -type d \
        -exec ${pkgs.acl}/bin/setfacl -m d:g:media:rwX {} +
    '';
  };

  systemd.timers.media-acl = {
    description = "Daily sweep of media group ACLs on /mnt/share";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
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
  users.users.audiobookshelf.extraGroups = [ "media" ];
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

  environment.systemPackages = with pkgs; [
    git
    gnumake
    nixfmt-tree

    tree-sitter
    neovim
  ];

  # jellyfin
  users.users.jellyfin.extraGroups = [ "media" ];
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-ocl
      intel-media-driver
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.jellyfin;
    hardwareAcceleration = {
      enable = true;
      device = "/dev/dri/renderD128";
    };
  };

  zramSwap.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 3;
    timeout = 3;
  };

  system.stateVersion = "26.05";
}

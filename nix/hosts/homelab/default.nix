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

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    nssmdns4 = true;
    enable = true;
    openFirewall = true;
  };
  # apps
  services = {
    audiobookshelf = {
      enable = true;
      openFirewall = true;
      port = 13378;
      host = "0.0.0.0";
    };
  };

  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      22 # OpenSSH
      80 # HTTP
      443 # HTTPS

      111 # NFS
      2049 # NFS
      4000 # NFS
      4001 # NFS
      4002 # NFS
    ];
    allowedUDPPorts = [
      111 # NFS
      2049 # NFS
      4000 # NFS
      4001 # NFS
      4002 # NFS
    ];
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
    networkmanager.enable = true;
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
    vim
    btop
  ];

  system.stateVersion = "26.05";
}

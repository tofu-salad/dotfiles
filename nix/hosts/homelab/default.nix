{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
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
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "share" = {
        "path" = "/mnt/share";
        "browseable" = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "tofu";
        "force group" = "media";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
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
    emby.enable = true;
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
      8096 # Emby
    ];
    allowedUDPPorts = [ ];
  };

  users.groups.media = { };
  users.users.emby.extraGroups = [ "media" ];
  users.users.tofu = {
    linger = true;
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

  system.activationScripts.mediaAcl = {
    text = ''
      echo "Setting ACLs on /mnt/share ..."
      ${pkgs.acl}/bin/setfacl -R -m g:media:rwX /mnt/share
      ${pkgs.acl}/bin/setfacl -R -m d:g:media:rwX /mnt/share
    '';
  };

  environment.systemPackages = with pkgs; [
    gh
  ];

  system.stateVersion = "26.05";
}

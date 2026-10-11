{
  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [
      config.services.tailscale.port
      111 # NFS
      2049 # NFS
      4000 # NFS
      4001 # NFS
      4002 # NFS
    ];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}

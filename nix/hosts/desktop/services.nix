{ pkgs, ... }:
{
  services = {
    tailscale.enable = true;

    # automount/unmount drives
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    avahi.enable = true;
  };

  # audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # this case has some front panel audio problems
  systemd.user.services.fix-automute = {
    description = "Disable ALSA auto-mute";
    wantedBy = [ "default.target" ];
    after = [ "wireplumber.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.alsa-utils}/bin/amixer -c 1 sset 'Auto-Mute Mode' Disabled";
    };
  };

}

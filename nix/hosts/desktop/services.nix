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
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    virt = {
      enable = mkEnableOption "virtualisation";
      docker = {
        enable = mkEnableOption "Docker";
      };
      virt-manager = {
        enable = mkEnableOption "virt-manager";
        user = mkOption {
          type = types.str;
          default = "tofu";
          description = "user to grant libvirtd access to";
        };
        gpuPass = {
          enable = mkEnableOption "GPU passthrough";
          gpu = mkOption {
            type = types.str;
            description = "gpu id example (1002:67df,1002:aaf0)";
          };
          lookingGlass = {
            enable = mkEnableOption "Looking Glass";
          };
        };
      };
    };
  };
  config = mkIf config.virt.enable (mkMerge [

    (mkIf config.virt.virt-manager.enable {
      programs.virt-manager.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      environment.systemPackages = with pkgs; [
        dnsmasq
      ];
      users.users.${config.virt.virt-manager.user}.extraGroups = [ "libvirtd" ];
      networking.firewall.trustedInterfaces = [ "virbr0" ];
    })
    (mkIf config.virt.virt-manager.gpuPass.enable {
      boot.initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
      boot.kernelParams = [
        "intel_iommu=on"
      ];
      boot.extraModprobeConfig = ''
        softdep drm pre: vfio-pci
        options vfio-pci ids=${config.virt.virt-manager.gpuPass.gpu}
      '';
    })
    (mkIf config.virt.virt-manager.gpuPass.lookingGlass.enable {
      boot.extraModprobeConfig = mkAfter ''
        options kvmfr static_size_mb=32
      '';
      virtualisation.libvirtd.qemu.verbatimConfig = ''
        cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/kvmfr0"
        ]
      '';
      boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
      boot.kernelModules = [ "kvmfr" ];

      services.udev.extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="${config.virt.virt-manager.user}", GROUP="kvm", MODE="0660"
      '';
      environment.systemPackages = with pkgs; [
        looking-glass-client
      ];
    })

    (mkIf config.virt.docker.enable {
      virtualisation.docker.enable = true;
    })
  ]);
}

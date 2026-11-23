{ pkgs, lib, host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) enableVirtualisation;
in
lib.mkIf enableVirtualisation {
  # only enable either docker or podman -- not both
  virtualisation = {
    docker.enable = true;
    podman.enable = false;

    libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = false;
        # ovmf submodule REMOVED: all ovmf images are now available by default in nixpkgs-unstable
        swtpm.enable = true; # tpm emulation
        verbatimConfig = ''
          user = "qemu-libvirtd"
          group = "kvm"
          dynamic_ownership = 1
          remember_owner = 0
        '';
      };
      allowedBridges = [
        "virbr0" # default nat bridge
        "br0" # custom bridge if needed
      ];
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer # view virtual machines
    lazydocker
    docker-client
    qemu_kvm # kvm support
    OVMF # uefi firmware
    swtpm # tpm emulation
    libguestfs # vm disk tools
    virt-top # monitor vm performance
    spice # spice protocol support
    spice-gtk # spice client gtk
    spice-protocol # spice protocol headers
    virglrenderer # virtual gpu support
    mesa # opengl support for vms
  ];

  # kvm kernel modules (loads the right one for the cpu)
  boot.kernelModules = ["kvm-amd" "kvm-intel"];

  # note: gpu/device passthrough (vfio) is not configured. to add it later,
  # enable iommu (amd_iommu/intel_iommu) and the vfio-pci kernel module.
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"
    "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"
  ];
}

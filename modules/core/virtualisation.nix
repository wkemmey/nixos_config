{pkgs, ...}: {
  # only enable either docker or podman -- not both
  virtualisation = {
    docker = {
      enable = true;
    };

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

    # kernel modules for better vm performance
    spiceUSBRedirection.enable = true;
  };

  programs = {
    virt-manager.enable = true;
    dconf.enable = true; # required for virt-manager settings
  };

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

  # enable necessary kernel modules for vm performance
  boot.kernelModules = ["kvm-amd" "kvm-intel" "vfio-pci"];

  # add boot kernel parameters for better graphics support
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  # enable opengl support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # create default iso and vm directories with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"
    "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"
  ];
}

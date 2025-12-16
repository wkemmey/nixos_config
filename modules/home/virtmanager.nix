{pkgs, ...}: {
  home.packages = with pkgs; [
    # additional vm management tools
    spice-gtk # better vm display performance
    virtio-win # windows guest drivers (for testing windows)
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    # virt-manager preferences for better distro testing
    "org/virt-manager/virt-manager" = {
      xmleditor-enabled = true; # enable xml editing for advanced configs
      stats-update-interval = 1; # update stats every second
      console-accels = true; # enable console accelerators
    };

    # vm viewer settings for better performance
    "org/virt-manager/virt-manager/console" = {
      resize-guest = 1; # automatically resize guest display
      scaling = 1; # scale to fit window
    };

    # default vm settings optimized for distro testing
    "org/virt-manager/virt-manager/new-vm" = {
      graphics-type = "spice"; # use spice for better performance
      cpu-default = "host-passthrough"; # better cpu performance
      storage-format = "qcow2"; # efficient disk format with snapshots
    };

    # console settings
    "org/virt-manager/virt-manager/urls" = {
      isos = ["/var/lib/libvirt/isos"]; # default iso location
    };
  };
}

{
  host,
  pkgs,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) gamingSupportEnable;
in
lib.mkIf gamingSupportEnable {
  # enable kernel modules for controller support
  boot.kernelModules = [
    "uinput"      # user input module for virtual devices
    "hid_nintendo" # nintendo switch pro controller and joy-cons support
    "xpad"        # xbox controller support
  ];

  # hardware configuration for controller support
  hardware = {
    # enable steam hardware udev rules (includes controller support)
    steam-hardware.enable = true;

    # enable xpadneo for better xbox controller support (especially for wireless)
    xpadneo.enable = true;
  };

  # additional udev rules for controller permissions and configuration
  services.udev.extraRules = ''
    # nintendo switch pro controller over usb
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"

    # nintendo switch pro controller over bluetooth
    KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666", TAG+="uaccess"

    # nyxi wizard 2 controller (appears as switch pro controller)
    # special rules to ensure back buttons are properly exposed to steam input
    SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", TAG+="steam-controller"
    SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", ENV{STEAM_INPUT_ENABLE}="1"
    SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/input/event%n"

    # nintendo switch joy-con (l)
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2006", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*057E:2006*", MODE="0666", TAG+="uaccess"

    # nintendo switch joy-con (r)
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2007", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*057E:2007*", MODE="0666", TAG+="uaccess"

    # nintendo switch joy-con charging grip
    KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="200e", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*057E:200E*", MODE="0666", TAG+="uaccess"

    # xbox one controller over usb
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b00", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b05", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b13", MODE="0666", TAG+="uaccess"

    # xbox series x|s controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b20", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b21", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b22", MODE="0666", TAG+="uaccess"

    # xbox 360 controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", MODE="0666", TAG+="uaccess"

    # flydigi vader 4 pro controller (dinput mode)
    KERNEL=="hidraw*", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", TAG+="steam-controller"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", ENV{STEAM_INPUT_ENABLE}="1"
    SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", ENV{ID_INPUT_JOYSTICK}=="1", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/input/event%n"

    # ultimate 2 2.4ghz/dongle and bluetooth
    KERNEL=="hidraw*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="2DC8:6012", MODE="0660", TAG+="uaccess"

    # generic rule for all game controllers
    SUBSYSTEM=="input", ATTRS{name}=="*Controller*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Gamepad*", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="*Joy-Con*", MODE="0666", TAG+="uaccess"
  '';

  # system packages for gaming support
  environment.systemPackages = with pkgs; [
    # gaming tools
    gamescope # gaming-focused wayland compositor
    protonup-qt # proton-ge and other compatibility tool installer

    # sdl2 with controller support
    SDL2

    # joystick testing and calibration tools
    jstest-gtk
    evtest

    # controller mapping tool
    antimicrox
  ];

  # enable joystick support in the kernel
  boot.kernelParams = [
    "usbhid.quirks=0x057e:0x2009:0x80000000"  # fix for switch pro controller
  ];
}

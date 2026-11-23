{ ... }:
{
  hardware = {
    # opengl/vulkan + 32-bit libraries (steam, older games)
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
}

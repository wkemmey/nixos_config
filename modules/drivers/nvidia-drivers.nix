{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.drivers.nvidia;
in
{
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };
  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      # modesetting is required
      modesetting.enable = true;
      # nvidia power management; experimental, and can cause sleep/suspend to fail
      powerManagement.enable = false;
      # fine-grained power management; turns off gpu when not in use
      # experimental and only works on modern nvidia gpus (turing or newer)
      powerManagement.finegrained = false;
      # use the nvidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver)
      # support is limited to the turing and later architectures; full list of
      # supported gpus is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # only available from driver 515.43.04+
      # currently alpha-quality/buggy, so false is currently the recommended setting
      open = true;
      # enable the nvidia settings menu, accessible via `nvidia-settings`
      nvidiaSettings = true;
      # optionally, you may need to select the appropriate driver version for your specific gpu
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
    
    # enable nvidia gpu monitoring in btop
    environment.systemPackages = [
      (pkgs.btop.override { cudaSupport = true; })
    ];
  };
}

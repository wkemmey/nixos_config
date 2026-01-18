{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # disable amd_pstate driver; ryzen 9 3900 (zen 2) uses acpi-cpufreq
  # set loglevel=4 to suppress debug messages and non-critical warnings during boot
  boot.kernelParams = [ "amd_pstate.enable=0" "loglevel=4" ];
}

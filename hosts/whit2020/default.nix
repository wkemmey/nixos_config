{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # disable amd_pstate driver; ryzen 9 3900 (zen 2) uses acpi-cpufreq
  boot.kernelParams = [ "amd_pstate.enable=0" ];
}

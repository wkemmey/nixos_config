{ host, ... }: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  # enable gpu drivers
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
}

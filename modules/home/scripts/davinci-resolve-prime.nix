{ pkgs }:

# Launcher script for DaVinci Resolve with NVIDIA Prime GPU offload
# Automatically sets required environment variables for dedicated GPU usage on hybrid laptop setups
# Use this on nvidia-laptop hosts instead of plain 'davinci-resolve' command

pkgs.writeShellScriptBin "davinci-resolve-prime" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __VK_LAYER_NV_optimus=NVIDIA_only
  exec davinci-resolve "$@"
''

{
  pkgs,
  inputs,
  username,
  host,
  profile,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) gitUsername;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # Enable Fish system-wide for vendor completions
  programs.fish.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit
        inputs
        username
        host
        profile
        ;
    };
    users.${username} = {
      imports = [ ./../home ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "adbusers"
      "docker"
      "libvirtd" # For VirtManager
      "lp"
      "networkmanager"
      "scanner"
      "wheel" # sudo access
      "vboxusers" # For VirtualBox
    ];
    # Use fish as default shell
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}

{ pkgs, inputs, username, host, profile, ... }:
let
  variables = import ../../hosts/${host}/variables.nix;
  inherit (variables) userFullName;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # enable fish system-wide for vendor completions
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
        stateVersion = "25.11";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${userFullName}";
    extraGroups = [
      "adbusers"
      "docker"
      "libvirtd" # for virtmanager
      "lp"
      "networkmanager"
      "scanner"
      "wheel" # sudo access
      "vboxusers" # for virtualbox
    ];
    # use fish as default shell
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}

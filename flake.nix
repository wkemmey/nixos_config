{
  description = "whit's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    #home-manager.url = "github:nix-community/home-manager/release-25.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    #nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    #nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    #nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    #disko.url = "github:nix-community/disko";
    #disko.inputs.nixpkgs.follows = "nixpkgs";

    #sops-nix.url = "github:Mic92/sops-nix";
    #sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    #fw-fanctrl = {
    #  url = "github:TamtamHero/fw-fanctrl/packaging/nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  #outputs = {
  #  self,
  #  nixpkgs,
  #  home-manager,
  #  disko,
  #  ...
  #} @ inputs: let
  #  inherit (self) outputs;
  #  systems = [
  #    "x86_64-linux"
  #    "aarch64-darwin"
  #  ];
  #  forAllSystems = nixpkgs.lib.genAttrs systems;
  #in {
  #  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  #  overlays = import ./overlays {inherit inputs;};
  #  nixosModules = import ./modules/nixos;
  #  homeManagerModules = import ./modules/home-manager;
  #  nixosConfigurations = {
  #    siegfried = nixpkgs.lib.nixosSystem {
  #      specialArgs = {inherit inputs outputs;};
  #      modules = [./machines/siegfried];
  #    };

  #    gawain = nixpkgs.lib.nixosSystem {
  #      specialArgs = {inherit inputs outputs;};
  #      modules = [./machines/gawain];

  outputs = { self, nixpkgs, hyprland, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        hyprland.nixosModules.default
      ];
    };
  };
}
To set up Hyprland on NixOS using flakes, you'll need to modify two files: flake.nix and configuration.nix.

flake.nix
First, you need to add Hyprland to your flake's inputs. This makes the Hyprland source code available to your system.

Nix

{
  description = "A basic NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, hyprland, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        hyprland.nixosModules.default
      ];
    };
  };
}
The key additions here are:

hyprland.url = "github:hyprwm/Hyprland";: This line adds the Hyprland repository as an input.

hyprland.inputs.nixpkgs.follows = "nixpkgs";: This ensures that the Hyprland input uses the same nixpkgs version as the rest of your system, preventing potential issues with mismatched packages.

hyprland.nixosModules.default: This line imports the Hyprland NixOS module, which handles all the necessary setup for the Hyprland compositor.

configuration.nix
Next, you need to enable Hyprland in your main NixOS configuration file and set up a basic user configuration. This file enables the Hyprland service, sets up a login manager, and configures the environment.

Nix

{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland.enable = true;

  # Enable a display manager for login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        user = "yourusername";
      };
    };
  };
  # Enable Hyprland configuration for the user
  users.users.yourusername = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      wayland-utils
      rofi
      kitty
      firefox
    ];
  };

  # Set up a basic Hyprland configuration
  # This section provides a minimal working config. You should customize it.
  # The configuration is written in the Hyprland format, not Nix.
  environment.etc."hypr/hyprland.conf".text = ''
    # Monitor setup
    monitor=,preferred,auto,1

    # Main keyboard and mouse binds
    $mainMod = SUPER

    bind = $mainMod, Q, exec, kitty
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, E, exec, rofi -show drun
    bind = $mainMod, V, togglefloating,

    # Window management
    bind = $mainMod, P, pseudo, # dwindle
    bind = $mainMod, J, togglesplit, # dwindle

    # Move focus
    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    # Move windows
    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d
    
    # Workspace switching
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4

    # Move windows to workspaces
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4

    # ... and many more
  '';

  # Additional services and packages
  services.xserver.enable = false; # Disable X11
  environment.systemPackages = with pkgs; [
    hyprland
  ];
}
Make sure to replace yourusername with your actual NixOS username. This configuration sets up a basic Hyprland environment with a few essential packages like rofi for an application launcher and kitty as a terminal.

After saving these changes, run nixos-rebuild switch --flake . to apply the new configuration.
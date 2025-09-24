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

  outputs = { self, nixpkgs, hyprland, ... }:
    let
      # custom settings that I can refer to elsewhere in my config
      mySettings = {
        system = "x86_64-linux"; # system arch
        hostname = "snowfire"; # hostname
        profile = "personal"; # select a profile defined from my profiles directory
        timezone = "America/Chicago"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = ""; # device identifier for grub; only used for legacy (bios) boot mode
        gpuType = "amd"; # amd, intel or nvidia; only makes some slight mods for amd at the moment
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "emmet"; # username
        name = "Emmet"; # name/identifier
        email = "emmet@librephoenix.com"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "io"; # selcted theme from my themes directory (./themes/)
        wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if ((wm == "hyprland") || (wm == "plasma")) then "wayland" else "x11";
        browser = "qutebrowser"; # Default browser; must select one from ./user/app/browser/
        spawnBrowser = if ((browser == "qutebrowser") && (wm == "hyprland")) then "qutebrowser-hyprprofile" else (if (browser == "qutebrowser") then "qutebrowser --qt-flag enable-gpu-rasterization --qt-flag enable-native-gpu-memory-buffers --qt-flag num-raster-threads=4" else browser); # Browser spawn command must be specail for qb, since it doesn't gpu accelerate by default (why?)
        defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
        term = "alacritty"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
        editor = "neovide"; # Default editor;
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
                        "emacsclient -c -a 'emacs'"
                      else
                        (if ((editor == "vim") ||
                             (editor == "nvim") ||
                             (editor == "nano")) then
                               "exec " + term + " -e " + editor
                         else
                         (if (editor == "neovide") then
                           "neovide -- --listen /tmp/nvimsocket" 
                           else
                           editor));
      };
    in {
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
          ];
          extraSpecialArgs = {
            inherit mySettings;
            #inherit inputs;
          };
        };
      };
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          hyprland.nixosModules.default
        ];
        specialArgs = {
          inherit mySettings;
          #inherit inputs;
        };
      };
    };
}
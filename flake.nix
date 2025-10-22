{
  description = "whit's nix config";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland = {
    #  url = "github:hyprwm/Hyprland";
    #  #inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable"; 
    #};

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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstablePkgs = nixpkgs-unstable.legacyPackages.${system};
      # custom settings that I can refer to elsewhere in my config
      mySettings = {
        username = "whit";
        name = "Whit Kemmey";
        email = "whit@fastmail.com";
        dotfilesDir = "~/.dotfiles";  # absolute path of the local repo
      };
    in {
      nixosConfigurations = {
        whit2023 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.whit = { #"${mySettings.username}" = {
                imports = [ ./home.nix ];
                #extraSpecialArgs = { inherit mySettings; };
              };
            }
            #pkgs.hyprland.nixosModules.default
            ({ ... }: {
              inherit pkgs;
              imports = [ pkgs.hyprland.nixosModules.default ];
            })
          ];
          specialArgs = {
            inherit mySettings unstablePkgs;
            hostname = "whit2023";
            bootMode = "uefi";  # uefi or bios
            #inherit inputs;
          };
        };

        nix_vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.whit = { #"${mySettings.username}" = {
                imports = [ ./home.nix ];
                #extraSpecialArgs = { inherit mySettings; };
              };
            }
            #pkgs.hyprland.nixosModules.default
            # CORRECT WAY to import the Hyprland module from Nixpkgs
            ({ ... }: {
              inherit pkgs;
              imports = [ pkgs.hyprland.nixosModules.default ];
            })
          ];
          specialArgs = {
            inherit mySettings unstablePkgs;
            hostname = "nix_vm";
            bootMode = "bios";  # uefi or bios
            #inherit inputs;
          };
        };
      };
    };
}
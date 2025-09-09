{
  description = "whit's nix config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    #home-manager.url = "github:nix-community/home-manager/release-25.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs = { self, nixpkgs }: {
      nixosConfigurations.nixos-flakes-btw = nixpkgs.lib.nixosSystem {
          modules = [ ./configuration.nix ];
      };
    };
  };
}

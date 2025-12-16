{
  description = "Black Don OS (Based on ZaneyOS)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser = {
      url = "github:fpletz/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, flake-utils, ... }@inputs:
    let
      system = "x86_64-linux";

      # helper function to create a host configuration
      mkHost =
        {
          hostname,
          profile,
          username,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            host = hostname;
            inherit profile;
            inherit username;
            helium-browser = inputs.helium-browser.packages.${system}.helium-browser;
          };
          modules = [
            ./profiles/${profile}
          ];
        };

    in
    {
      nixosConfigurations = {
        # default template configuration
        # users will create their own host configurations during installation
        default = mkHost {
          hostname = "default";
          profile = "amd";
          username = "user";
        };

        whit2020 = mkHost {
          hostname = "whit2020";
          profile = "amd";
          username = "whit";
        };

        whit2023 = mkHost {
          hostname = "whit2023";
          profile = "nvidia";
          username = "whit";
        };

      };

      # Flutter development environment
#      devShells = flake-utils.lib.eachDefaultSystem (
#        system:
#        let
#          pkgs = import nixpkgs {
#            inherit system;
#            config = {
#              android_sdk.accept_license = true;
#              allowUnfree = true;
#            };
#          };
#          buildToolsVersion = "33.0.2";
#          androidComposition = pkgs.androidenv.composeAndroidPackages {
#            buildToolsVersions = [ buildToolsVersion ];
#            platformVersions = [ "33" ];
#            abiVersions = [ "arm64-v8a" ];
#          };
#          androidSdk = androidComposition.androidsdk;
#        in
#        {
#          default =
#            with pkgs;
#            mkShell rec {
#              ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
#              buildInputs = [
#                flutter
#                androidSdk
#                jdk11
#              ];
#            };
#        }
#      );
    };
}

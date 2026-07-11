/*

flake.nix
-> Get profile information
  - Architecture
  - Hostname
  - Package repository
  - System configurations
-> Get packages

profile/default.nix
-> Exports MacOS profile
  nix-darwin.lib.darwinSystem
    - system
      specialArgs
      modules
        - home-manager (for config files)
          -> ./configs
        - brew
          -> ./modules/brew
        - system packages
          -> ./modules/base.nix
        - system configuration
          -> ./machines/macos

Configurations
->


-> vanilla (the base configuration)




*/

{
  description = "Matthew Tindley's NIX configuration";

  inputs = {
    # The Nix Package Repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Used to structure flakes
    flake-parts.url = "github:hercules-ci/flake-parts";

    # nix-darwin for MacOS configuration
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
        url = "github:BatteredBunny/brew-nix";
        inputs.brew-api.follows = "brew-api";
        inputs.nix-darwin.follows = "nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    brew-api = {
        url = "github:BatteredBunny/brew-api";
        flake = false;
    };

    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
        url = "github:tinted-theming/schemes";
        flake = false;
    };

    # FUTURE: pull in nixos manager

  };

  outputs = inputs@{ self, flake-parts, ... }:
  let
      nixpkgs = {
          overlays = [
              inputs.brew-nix.overlays.default
          ];
      };

      mkFlake = flake-parts.lib.mkFlake { inherit inputs; };
  in


  mkFlake {
        systems = [ "aarch64-darwin" "x86_64-linux" ];


        perSystem = { config, self', inputs', pkgs, system, lib, ... }:
        let
            darwin = system == "aarch64-darwin";

            cfg = if darwin then {}
            else
            {
                nixosConfigurations.vanilla = lib.nixosSystem {
                    system = system;

                    specialArgs = { user = "matt"; };

                    modules = [
                        ./machines/linux.nix

                        inputs'.home-manager.home-manager {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPkgs = true;
                            home-manager.users.matthewtindley = ./users/matthewtindley.nix;
                        }
                    ];

                };
            };
        in
        cfg;

      flake = { ... }: {
          darwinConfigurations = (
              # Create a new darwin system configuration
              # This will call darwin.lib.darwinSystem and return it
              import ./machines/darwin.nix {
                self = self;
                name = "base"; # Name of the configuration
                user = "matthewtindley";
                nixpkgs = nixpkgs;

                modules = [
                    inputs.brew-nix.darwinModules.default
                ];

                darwin = inputs.nix-darwin;
                home-manager = inputs.home-manager;

                base16 = inputs.base16;
                tt-schemes = inputs.tt-schemes;
              }
          );
      };

  };


  /*
  Darwin (MacOS) configurations:
    - base

  */
  # {

  #   # nix-darwin reads out configurations
  #   # from the darwinConfigurations variable
  #   darwinConfigurations = (

  #     # Create a new darwin system configuration
  #     # This will call darwin.lib.darwinSystem and return it
  #     import ./machines/darwin.nix {
  #       self = self;
  #       name = "base"; # Name of the configuration
  #       user = "matthewtindley";
  #       nixpkgs = nixpkgs;

  #       modules = [
  #           inputs.brew-nix.darwinModules.default
  #       ];

  #       darwin = inputs.nix-darwin;
  #       home-manager = inputs.home-manager;

  #       base16 = inputs.base16;
  #       tt-schemes = inputs.tt-schemes;
  #     }


  #   );

  # };
}

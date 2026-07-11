{
  description = "Homebrew Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-homebrew.url ="github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-azure = {
      url = "github:homebrew/homebrew-azure"
    }
  };

  outputs = inputs@{ self, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask }:
  let
  in
  {
    darwin = nix-homebrew.darwinModules.nix-homebrew {
      nix-homebrew = {
        enable = true;
        user = "matthewtindley";
        autoMigrate = true;
        taps = {
          "homebrew/homebrew-core" = homebrew-core;
          "homebrew/homebrew-cask" = homebrew-cask;
        };
        mutableTaps = false;
      };
    };
  }
}


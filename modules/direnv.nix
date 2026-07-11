{ config, pkgs, user, ... }:
let
in

{
    home.packages = [
        pkgs.direnv
        pkgs.nix-direnv
    ];

    programs = {
        direnv = {
            enable = true;
            package = pkgs.direnv;
            enableNushellIntegration = true;
            nix-direnv.enable =true;
        };
    };
}

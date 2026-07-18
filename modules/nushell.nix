{ config, pkgs, user, lib, ... }:
let
in

{

    home.packages = [
        pkgs.nushell
        pkgs.starship
    ];

    programs.nushell = {
        enable = true;
        package = pkgs.nushell;

        # TODO: Symlink to home?
        configFile.source = ../dotfiles/nushell.nu;

        # Apprently sessionPath does not work with nushell
        # this work around appends sessionPath to nushell $env.PATH
        extraConfig = lib.optionalString (config.home.sessionPath != [ ]) ''
            $env.PATH ++= [${lib.concatStringsSep ", " config.home.sessionPath}]
        '';

        shellAliases = {
            "q" = "exit";
            "cd" = "z";
        };
    };


    programs.starship = {
        enable = true;
        enableNushellIntegration = true;

    };
}

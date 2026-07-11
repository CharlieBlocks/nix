{ config, pkgs, user, ... }:
let
in

{
    home.packages = [
        pkgs.zellij
    ];

    programs.zellij = {
        enable = true;
        package = pkgs.zellij;
    };
    home.file.".config/zellij/config.kdl" = {
        text = (builtins.readFile ./../dotfiles/zellij.kdl)
            + ''default_shell "${pkgs.nushell}/bin/nu";'';
    };

    home.sessionPath = [
        "${pkgs.zellij}/bin"
    ];
}

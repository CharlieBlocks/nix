{ config, pkgs, user, ... }:
let
in

{
    home.packages = [
        pkgs.zoxide
        pkgs.fzf
    ];

    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
    };

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };


    # Because zoxide & fzf is not seemingly added to PATH
    home.sessionPath = [
        "${pkgs.zoxide}/bin"
        "${pkgs.fzf}/bin"
    ];
}

{ config, pkgs, ... }:
let
in

{
    home.packages = [
        pkgs.zed-editor
    ];

    programs.zed-editor = {
        enable = true;

        extensions = [ "nix" "toml" "rust" ];

        themes = {
            "nix" = {
                name = "nix";
                author = "Nix";
                style = {

                };
            };
        };

        userSettings = {
            theme = {
                mode = = "system";
                light = "One Light";
                dark = "Catppuccin Mocha"
            };
        };

        userKeymaps = {

        };
    };
}

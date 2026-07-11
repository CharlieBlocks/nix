{ config, pkgs, user, ... }:
let
in

{
    home.packages = [
        pkgs.brewCasks.ghostty
    ];

    programs.ghostty = {
        enable = true;
        package = pkgs.brewCasks.ghostty;

        settings = {
            command = "${pkgs.nushell}/bin/nu";
            theme = "nix";
            shell-integration = "nushell";

            background-opacity = "1";
            window-padding-x = "10,10";
            window-padding-y = "10,10";
            # window-decoration = "none";
            macos-titlebar-style = "hidden";
        };

        themes = {
            nix = with config.scheme.withHashtag; {
                palette = [
                    "0=${base03}" # black
                    "1=${base08}" # maroon
                    "2=${base0B}" # green
                    "3=${base0A}" # olive
                    "4=${base0D}" # navy
                    "5=${base17}" # purple
                    "6=${base0C}" # teal
                    "7=#a6adc8" # silver (subtext 0)
                    "8=${base04}" # grey
                    "9=${base12}"  # red
                    "10=${base14}" # lime
                    "11=${base09}" # yellow
                    "12=${base16}" # blue
                    "13=${base0E}" # fuchsia
                    "14=${base15}" # Aqua
                    "15=${base06}" # White
                ];
                background = base00;
                foreground = base05;
                cursor-color = base06;
                cursor-text = base00;
                selection-background = base04;
                selection-foreground = base05;
            };
        };
    };
}

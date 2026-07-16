{ lib, pkgs, config }:
let
    shells = {
        "zsh" = pkgs.zsh;
        "nushell" = pkgs.nushell;
    };

    emulators = {
        "none" = {}: {};
        "tmux" = import ./tmux.nix
        "zellij" = {}: {};
    };

in
{

    options.apps = {
        alacritty = {
            enable = lib.mkEnableOption "Enable Alacritty";
            shell = lib.mkOption {
                type = lib.types.oneOf [ "zsh" "nushell" ];
                default = "zsh";
                description = "The shell to use";
            };

            emulator = lib.mkOption {
                type = lib.types.oneOf [ "none" "tmux" "zellij" ];
                default = "none";
                description = "The terminal emulator to use. If set then it will be launched on startup by default";
            };

            extras = {
                zoxide = lib.mkEnableOption "Include zoxide";
            };
         };
    };


    programs.alacritty = lib.mkIf config.apps.alacritty.enable {
        enable = true;

        settings = {

            env = {
                TERM = "xterm-256color";
            };

            terminal.shell = "${shells[config.apps.alacritty.shell]}/bin/${config.apps.alacritty.shell}";

            colors = {
                primary = {
                    background = "${config.scheme.withHashtag.base00}";
                    foreground = "${config.scheme.withHashtag.base05}";
                };
                normal = {
                    black   = "${config.scheme.withHashtag.base00}";
                    red     = "${config.scheme.withHashtag.base08}";
                    green   = "${config.scheme.withHashtag.base0B}";
                    yellow  = "${config.scheme.withHashtag.base0A}";
                    blue    = "${config.scheme.withHashtag.base0D}";
                    magenta = "${config.scheme.withHashtag.base0E}";
                    cyan    = "${config.scheme.withHashtag.base0C}";
                    white   = "${config.scheme.withHashtag.base05}";
                };
            };

            font = {
                normal = { family = "JetBrainsMonoNL NF"; style = "Regular"; };
                bold = { style = "Bold"; };
                italic = { style = "Italic"; };
                bold_italic = { style = "Bold Italic"; };

                size = 14;
            };

            selection = {
                save_to_clipboard = true;
            };

            cursor = {
                style = { shape = "Block"; vi_mode_style = { shape = "Block"; blinking = "Off"; }; };
                unfocused_hollow = true;
                thickness = 0.15;
            };

            mouse = {
                hide_when_typing = false;
            };

            keyboard.bindings = [ ];

            window = {
                padding = {
                    decorations = "Transparent";

                    top = 30;
                    left = 4;
                    right = 4;

                    opacity = 1;
                    blur = true;
                    resize_increments = true;
                    option_as_alt = "OnlyLeft";
                };
            };

            scrolling = {
                history = 10000;
                multiplier = 1;
            };

            hints.enabled = [
                {
                    command = "open";
                    hyperlinks = true;
                    post_processing = true;
                    persist = false;
                    mouse.enabled = true;
                }
            ];
        };
    };

} // emulators[config.apps.alacritty.emulator]

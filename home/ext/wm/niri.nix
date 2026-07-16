{ lib, pkgs, config }: {

    options.apps = {
        niri = {
            enable = lib.mkEnableOption "Enable Niri. A scrolling window manager";
            wallpaper = lib.mkOption {
                type = lib.types.str;
                description = "The URL of the wallpaper to use"
            };
        };
    };

    programs.niri = lib.mkIf config.apps.niri.enable {
        enable = true;

        /*
        Can be set to:
        - niri
        - niri-stable
        - niri-unstable
        */
        package = pkgs.niri-stable;


        settings = {
            prefer-no-csd = true;

            input = {
                keyboard = {
                    xkb = {
                        layout = "gb";
                        variant = "extd"
                    };

                    repeat-delay = 600;
                    repeat-rate = 25;

                    numlock = true;
                };

                mouse = {
                    natural-scroll = false;
                    accel-speed = 0;
                    accel-profile = "flat";
                    left-handed = false;
                    middle-emulation = false;
                    scroll-factor = 0;
                };

                warp-mouse-to-focus = "center-xy";
                focus-follows-mouse = {
                    enable = true;
                    max-scroll-amount = "50%";
                };

                mod-key = "Super";
                mod-key-nested = "Alt";
            };

            layout = {
                gaps = 16;
                center-focused-column = "never";
                empty-workspace-above-first = true;
                default-column-display = "normal";
                default-column-width = { proportion = 1. / 2.; };
                focus-ring = {
                    width = 1;
                    # TODO: GET FROM THEME
                    active-color = "blue";
                };
                shadow.enable = false;
                tab-indicator = {
                    enable = true;
                    corner-radius = 4;
                    gap = 5.;
                    hide-when-single-tab = false;
                    total-proportion = 0.5;
                    position = "left";
                };
                struts = {
                    enabled = true;
                    left = 0;
                    right = 0;
                    top = 20;
                    bottom = 0;
                };
                # TODO: Get from theme
                # technically not shown when we have a wallpaper but
                # it would be nice to not look hideous if the wallpaper
                # goes wrong
                background-color = "gray";
            };
        };

        outputs = {
           # Find outputs using niri msg outputs
           # https://niri-wm.github.io/niri/Configuration%3A-Outputs.html
        };

        # Get all axtions using niri msg action
        # https://niri-wm.github.io/niri/Configuration%3A-Key-Bindings.html#actions
        binds = {
            # Movement Binds
            "Mod+Right" = { action.focus-column-right = true; hotkey-overlay = { title = "Select next right window"; }; };
            "Mod+Left" = { action.focus-column-left = true; hotkey-overlay = { title = "Select previous left window"; }; };
            "Mod+Down" = { action.focus-window-down = true; hotkey-overlay = { title = "Select the below window"; }; };
            "Mod+Up" = { action.focus-window-up = true; hotkey-overlay = { title = "Select the above window"; }; };
            "Mod+L" = { action.focus-column-right = true; hotkey-overlay = { title = "Select next right window"; }; };
            "Mod+H" = { action.focus-column-left = true; hotkey-overlay = { title = "Select previous left window"; }; };
            "Mod+J" = { action.focus-window-down = true; hotkey-overlay = { title = "Select the below window"; }; };
            "Mod+K" = { action.focus-window-up = true; hotkey-overlay = { title = "Select the above window"; }; };

            # Window Movement Binds
            "Mod+Ctrl+L" = { action.move-column-right = true; hotkey-overlay = { title = "Move window right"; }; };
            "Mod+Ctrl+H" = { action.move-column-left = true; hotkey-overlay = { title = "Move window left"; }; };
            "Mod+Ctrl+J" = { action.move-window-down = true; hotkey-overlay = { title = "Move window down"; }; };
            "Mod+Ctrl+K" = { action.move-window-up = true; hotkey-overlay = { title = "Move window up"; }; };

            # Window Management
            "Mod+Escape"    = { action.toggle-overview = true; repeat = false; hotkey-overlay = { title = "Toggle Overview"; }; };
            "Mod+Backspace" = { action.close-window = true; repeat = false; hotkey-overlay = { title = "Close Window"; }; };

            # Function Keys
            "XF86AudioRaiseVolume"  = { action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ]; allow-when-locked = true; };
            "XF86AudioLowerVolume"  = { action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ]; allow-when-locked = true; };
            "XF86AudioMute"         = { action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; allow-when-locked = true; };

            "XF86AudioPlay"         = { action.spawn = [ "playerctl" "play-pause" ]; allow-when-locked = true; };
            "XF86AudioStop"         = { action.spawn = [ "playerctl" "stop" ]; allow-when-locked = true; };
            "XF86AudioPrev"         = { action.spawn = [ "playerctl" "previous" ]; allow-when-locked = true; };
            "XF86AudioNext"         = { action.spawn = [ "playerctl" "next" ]; allow-when-locked = true; };

            "XF86MonBrightnessUp"   = { action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ]; allow-when-locked = true; };
            "XF86MonBrightnessDown" = { action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ]; allow-when-locked = true; };
        };


        settings = {

            workspaces = {
                "comms" = {
                    # open-on-output = "" // find monitor name
                };
                "music" = {
                    # open-on-output = ""
                };
            };

            window-rules = {

            };

        };
    };

}

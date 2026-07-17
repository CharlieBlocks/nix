{ pkgs, ... }: {

    imports = [
        /*
        Configuration for the hardware of xl1.
        */
        ./hardware.nix
    ];


    ##=================================================================##
    ## Locale Configuration                                            ##
    ##      This involves setting keyboard, time and unit preferences. ##
    ##      As someone diagnosed with being terminally british I       ##
    ##      use the 'uk' keymap. (BTW to any american reading this, it ##
    ##      is spelt colour with a 'u'!)                               ##
    ##=================================================================##
    time.timeZone = "Europe/London";
    i18n = {
        defaultLocale = "en_GB.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "en_GB.UTF-8";
            LC_IDENTIFICATION = "en_GB.UTF-8";
            LC_MEASUREMENT = "en_GB.UTF-8";
            LC_MONETARY = "en_GB.UTF-8";
            LC_NAME = "en_GB.UTF-8";
            LC_NUMERIC = "en_GB.UTF-8";
            LC_PAPER = "en_GB.UTF-8";
            LC_TELEPHONE = "en_GB.UTF-8";
            LC_TIME = "en_GB.UTF-8";
        };
    };

    console = {
        earlySetup = true;
        keyMap = "uk";
    };


    ##=========================================##
    ## Nix Configuration                       ##
    ##      Configuration for the nix service. ##
    ##=========================================##
    nix = {
        channel.enable = false;

        gc = {
            automatic = true;

            # Run every 7 days
            dates = [ "Mon *-*-* 00:00:00" ];
            options = "--delete-older-than 2d";
        };

        # Run file depuplication within the nix store
        # Currently disabled
        optimise = {
          automatic = false;
          dates = [ "Mon *-*-* 00:00:00" ];
        };

        # Builder Settings
        settings = {
          allowed-users = [ "root" "matt" ];
          trusted-users = [ "root" "matt" ];

          # Enforces that binary cache downloads are cryptographically signed.
          require-sigs = true;

          auto-optimise-store = true;

          # Use all available cores (18 on my M3 Pro)
          cores = 0;
          max-jobs = "auto";

          # Enforces that all Nix builds are sandboxed and "pure"
          # May break some builds
          sandbox = true;

          experimental-features = [ "nix-command" "flakes" ];
        };
    };

    nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = "x86_64-linux";
    };


    ##=================================================================##
    ## System Services                                                 ##
    ##      These are systemd services that run in the background. One ##
    ##      of the core services we add is ly as our display           ##
    ##      come login manager.                                        ##
    ##=================================================================##
    services = {
        /*
        I prefer ly as my display manager because of how simple it is.
        I don't currently have it set up but the backgrounds can be
        customised with durdraw animations.
        */
        displayManager.ly = {
            enable = true;
            settings = {
                animate = false;
                animation = "dur_file";
                animation_frame_delay = 5;
                animation_timeout_sec = 0;

                # dur_file_path =  ${inputs.anim}
                dur_offset_alignment = "center";
                dur_x_offset = 0;
                dur_y_offset = 0;
                edge_margin = 0;

                corner_top_right = "clock";
          		corner_bottom_left = "version";
          		corner_bottom_right = "numlock,capslock";

          		clock = "%a %b %d - %H:%M:%S %Z";
          		asterisk = "*";
          		blank_password = true;
          		blank_box = false;
          		margin_box_h = 6;
          		margin_box_v = 3;
          		input_len = 40;
          		hide_key_hints = true;
            };
        };
    };



    ##============================================================##
    ## Base Programs                                              ##
    ##      While we install per-user programs using home-manager ##
    ##      we add some base programs so all users have access to ##
    ##      them even if the users get messed up                  ##
    ##============================================================##
    environment = {
        systemPackages = with pkgs; [
            coreutils
            vim
            wget
            curl
            jq
            git
            firefox
            zsh
            alacritty
        ];

        shells = [ pkgs.zsh ];

        sessionVariables = {
            NIXOS_OZONE_WL = "1";
        };

	/*
	This is required to ensure that XDG works correctly with
	the home-manager modules.
	*/
	pathsToLink = [
	    "/share/applications"
	    "/share/xdg-desktop-portal"
	];
    };

    users = {
        defaultUserShell = pkgs.zsh;
    };
}

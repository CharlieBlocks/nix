{ ... }: {

    system = {
        configurationRevision = self.rev or self.dirtyRev or null;
        stateVersion = 7;
        primaryUser = "root";

        # https://github.com/nix-darwin/nix-darwin/issues/518#issuecomment-2691433665
        activationScripts.postActivation.text = ''
            # Following line should allow us to avoid a logout/login cycle when changing settings
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
    };



    ##================================================##
    ## Locale Configuration                           ##
    ##      Here we configure the locale information. ##
    ##      This includes our timezone and unit       ##
    ##      preferences.                              ##
    ##================================================##
    # https://mynixos.com/nix-darwin/options/time
    # Europe/London corresponds to GMT(UTC)/BST
    time.timeZone = "Europe/London";

    # https://mynixos.com/nix-darwin/options/system.defaults.NSGlobalDomain
    # This modifies the Apple defaults list
    # which is similar to the window registry
    # we set our preferred units and input options
    system.defaults.NSGlobalDomain = {
        # Set to use metrics
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";

        # Use the 24 hour clock
        AppleICUForce24HourTime = true;

        # Use Dark mode
        AppleInterfaceStyle = "Dark";

        _HIHideMenuBar = false;
    };

    # https://mynixos.com/nix-darwin/options/system.keyboard
    # Remaps CAPS to CTRL
    system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
    };


    ##==================================================##
    ## Security Configuration                           ##
    ##      This configures what authentication methods ##
    ##      are accepted by the system.                 ##
    ##==================================================##
    security = {
        # https://mynixos.com/nix-darwin/options/security.pam.services.sudo_local
        pam.services.sudo_local = {
            touchIdAuth = true;
            watchIdAuth = false; # I do not use an apple watch
        }
    };




    ##==================================================##
    ## Nix Configuration                                ##
    ##      Here we configure the nix daemon as well as ##
    ##      as nixpkgs and our brew manager.            ##
    ##==================================================##
    # https://mynixos.com/nix-darwin/options/nix
    nix = {

        # Disable channels
        channel.enable = false;

        # Enable the garbage collector
        gc = {
            automatic = true;

            # Run every 7 days
            interval = { Hour = 0; Minute = 0; Weekday = 7; };
            options = "--delete-older-than 2d";
        };

        # Run file depuplication within the nix store
        # Currently disabled
        optimise = {
          automatic = false;
          interval = { Hour = 0; Minute = 0; Weekday = 7; };
        };

        # Builder Settings
        settings = {
          allowed-users = [ "root" ];
          trusted-users = [ "root" ];

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

    # https://mynixos.com/nix-darwin/options/nixpkgs
    nixpkgs = {
      # Allows software that is not licensed under a free license to
      # be installed
      config = { allowBroken = false; allowUnfree = true; };

      # Tell nixpkgs to use aarch64_darwin packages
      hostPlatform = "aarch64-darwin";
      buildPlatform = "aarch64-darwin";
    };

    # Enables brew-nix
    brew-nix.enable = true;

}

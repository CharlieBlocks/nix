{ pkgs, user, ... }:

/*  All outputs here relate to nix-darwin options */
{
  # Imports

  # Environment
  # https://mynixos.com/nix-darwin/options/environment
  environment = {

    # Shell configuration
    # prefer ZSH
    shells = [
      pkgs.bashInteractive
      pkgs.zsh
      pkgs.nushell
    ];


    # Package Configuration
    systemPackages = with pkgs; [
      coreutils

      wget
      curl
      jq
      zsh

      # Temp
      # pkgs.direnv
      # pkgs.nix-direnv
    ];
    systemPath = [ ];

  };

  # MacOS User & Shell
  # https://mynixos.com/nix-darwin/options/users
  # users.users."${user}" = {
  #   home = "/Users/${user}";
  #   shell = nixpkgs.zsh;
  # };

  # Program Configuration
  # https://mynixos.com/nix-darwin/options/programs
  programs = {

    # https://mynixos.com/nix-darwin/options/programs.zsh
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableFzfCompletion = true;
      enableFzfHistory = true;
      enableSyntaxHighlighting = true;
      histFile = "/Users/${user}/.zhistory";
      histSize = 10000;
    };

    # https://mynixos.com/nix-darwin/options/programs.man
    man.enable = true;

  };


  # Time Zone
  # https://mynixos.com/nix-darwin/options/time
  time.timeZone = "Europe/London"; # GMT/BST



  # Services
  # https://mynixos.com/nix-darwin/options/services
  services = {

    # Enable aerospace

    # Enable nix-daemon?

  };

  # Nix Configuration
  # https://mynixos.com/nix-darwin/options/nix
  nix = {
    # Configure build machines if using
    # a non-local builder
    # https://mynixos.com/nix-darwin/options/nix.buildMachines.*

    # I'm using nix flakes over channels
    channel.enable = false;

    # Garbage collection for the nix-store
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
      allowed-users = [ "root" "${user}" ];
      trusted-users = [ "root" "${user}" ];

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

  # Network Configuration
  # https://mynixos.com/nix-darwin/options/networking
  networking = {
    # Set hostname
    # Set compute name
    # Set DNS
  };

  # https://mynixos.com/nix-darwin/options/security
  security = {
    pam.services.sudo_local = {
      touchIdAuth = true;
      watchIdAuth = false; # I do not currently use an apple watch
    };

    # May be useful
    # sandbox.profiles.<name>.allowNetworking
  };


  system = {

    # System Configuration
    defaults = {

      # Dock Configuration
      dock = {
        autohide = true;
        show-recents = false;
        showhidden = true;

        # Gestures
        showAppExposeGestureEnabled = true;
        showDesktopGestureEnabled = false;
        showLaunchpadGestureEnabled = false;
        showMissionControlGestureEnabled = true;

        mineffect = "scale";
        largesize = 16;
        tilesize = 49;
        minimize-to-application = true;

        persistent-apps = [
          # Add shell
          "/Applications/Safari.app"
          "/Applications/Music.app"
          "/Applications/Mail.app"
          "/Applications/Calendar.app"
        ];
      };


      # Finder Configuration
      finder = {
        _FXSortFoldersFirst = true;

        # Hides files on the desktop
        CreateDesktop = false;

        # Search will automatically check
        # within the current folder rather than "This Mac"
        FXDefaultSearchScope = "SCcf";

        # Don't warn when changing the extension of a file
        FXEnableExtensionChangeWarning = false;

        # Set the preferred view style to columns
        FXPreferredViewStyle = "clmv";

        # Opens new Finder windows to my Home directory
        NewWindowTarget = "Home";

        # Enables CMD-Q on Finder
        QuitMenuItem = true;

        # Don't show drives on the desktop
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;

        # Shows a pathbar in the finder window with
        # a breadcrumb trail. Makes navigation up a directory
        # easier
        ShowPathbar = true;

        # Shows current disk & available space
        ShowStatusBar = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      # Global Configuration
      NSGlobalDomain = {

        # Keep menu bar on screen
        _HIHideMenuBar = false;

        # Set to use metrics
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";

        # Use the 24 hour clock
        AppleICUForce24HourTime = true;

        # Use Dark mode
        AppleInterfaceStyle = "Dark";

        KeyRepeat = 1;
      };

      # TODO: Finish Defaults
    };

    tools = {
      darwin-rebuild.enable = true;
      darwin-uninstaller.enable = true;
    };

    stateVersion = 6;

    primaryUser = "root";
  };


  launchd.user.agents.UserKeyMapping.serviceConfig = {
      ProgramArguments = [
          "/usr/bin/hidutil"
          "property"
          "--match"
          "{&quot;ProductID&quot;:0x0,&quot;VendorID&quot;:0x0,&quot;Product&quot;:&quot;Apple Internal Keyboard / Trackpad&quot;}"
          "--set"
          (
              let
                  capslock = "0x700000039";
                  leftCtrl = "0x7000000E0";
              in
              "{&quot;UserKeyMapping&quot;:[{&quot;HIDKeyboardModifierMappingDst&quot;:${capslock},&quot;HIDKeyboardModifierMappingSrc&quot;:${leftCtrl}}]}"
          )
      ];
      RunAtLoad = true;
  };


  # Fonts
  # Homebrew
  brew-nix.enable = true;

}

{ configs, pkgs, lib, inputs, ... }: 
{
    ## ====================== ##
    ## Hardware Configuration ##
    ## ====================== ##
    boot = {
        loader = {
            limine = {
                enable = true;
                efiSupport = true;
                resolution = "1920x1080x32";
                enableEditor = false;
                maxGenerations = 10;

                # TODO: CONFIGURE WALLPAPER!
            };
            systemd-boot.enable = lib.mkForce false;
            grub.enable = lib.mkForce false;

            efi.canTouchEfiVariables = true;
            timeout = 5;
        };

        initrd = {
            availableKernelModules = [ "uhci_hcd" "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" ];
            kernelModules = [];
        };

        kernelPackages = pkgs.linuxPackages_latest;
        kernelModules = [ ];
        extraModulePackages = [ ];
    };



    ## ========================= ##
    ## File System Configuration ##
    ## ========================= ##
    fileSystems."/" = {
        device = "/dev/sda7";
        fsType = "ext4";
    };

    fileSystems."/home" = {
        device = "/dev/sdb4";
        fsType = "btrfs";
    };

    fileSystems."/boot" = {
        device = "/dev/sdb2";
        fsType = "vfat";
    };


    swapDevices = [{
        device = "/dev/sda5";
    }];


    hardware = {
        opengl.enable = true;
        nvidia.modesetting.enable = true;
    };


    ## ======================##
    ## Network Configuration ##
    ## ======================##
    networking = {
        networkmanager.enable = true;
        hostName = "nixos-desktop";
    };



    ##========##
    ## Locale ##
    ##========##
    time.timeZone = "Europe/London";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
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

    console = {
	earlySetup = true;
	keyMap = "uk";
	font = "${pkgs.terminus_font}/share/consolefonts/ter-116n.psf.gz";
	packages = with pkgs; [ terminus_font ];
    };



    ##=================##
    ## System Packages ##
    ##=================##
    nixpkgs.config.allowUnfree = true;
    environment = {
        systemPackages = with pkgs; [
            coreutils
            vim
            wget
            curl
            jq
            git

            zsh
	    kitty
        ];

        shells = [ pkgs.zsh ];

        sessionVariables = {
            # If cursor doesn't show up
            # WLR_NO_HARDWARE_CURSORS = "1";

            NIXOS_OZONE_WL = "1";
        };
    };
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
    };
    programs.man.enable = true;

    programs.hyprland = {
        enable = true;
        xwayland.enable = false;
	withUWSM = true;
	# If installed using HomeManager ensure that hyprland.systemd.enable is false
    };

    programs.firefox.enable = true;



    ##=================##
    ## System Services ##
    ##=================##
    services = {
        displayManager.ly = {
	    enable = true;
	    settings = {
		animate = false;
		animation = "dur_file";
		animation_frame_delay = 5;
		animation_timeout_sec = 0;
		dur_file_path = "${inputs.ly-anim}/animations/dur/blackhole-smooth-240x67.dur";
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



    ##===================##
    ## Nix Configuration ##
    ##===================##
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


    ## TEMPORARY USER DEF ##
    users.users."matt" = {
        isNormalUser = true;
        description = "matt";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = [];
    };

}

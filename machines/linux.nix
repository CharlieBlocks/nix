{ configs, pkgs, lib, ... }: {
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
        size = 16*1024; # 16G
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
        hostname = "nixos-desktop";
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
    console.keyMap = "uk";



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
        ];

        shells = [ pkgs.zsh ];

        programs.zsh = {
            enable = true;
            enableAutosuggestions = true;
            enableCompletion = true;
        };
        programs.man.enable = true;

        programs.hyprland = {
            enable = true;
            nvidiaPatches = true;
            xwayland.enable = false;
        };

        sessionVariables = {
            # If cursor doesn't show up
            # WLR_NO_HARDWARE_CURSORS = "1";

            NIXOS_OZONE_WL = "1";
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

}

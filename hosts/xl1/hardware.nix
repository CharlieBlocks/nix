{ ... }: {

    ##========================================================##
    ## Boot Configuration                                     ##
    ##      The boot configuration consists of kernel modules ##
    ##      my bootloader choice. I choose to use limine over ##
    ##      GRUB as I find it to be a little lighter weight   ##
    ##      and less effort to work with.                     ##
    ##========================================================##
    boot = {

        /*
        I'm not perfectly familiar with the core of linux howerver the initrd
        system is the kernel being loaded into ram. From there we can run the
        other programs required to initialise the system. We need the kernel
        modules below so that we can interface with hardware during setup.

        There are a lot of options for this but we don't need to touch most of them.
        */
        initrd = {
            availableKernelModules = [ "uhci_hcd" "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" ];
            kernelModules = [];
            kernelModules = [ "kvm-intel" ];
            extraModulesPackages = [ ];
        };

        /*
        I'm leaving this here for future reference. Nix only has so much control
        over the bootloader process. My system was dual booting and, despite being
        set to use limine, it would keep booting into systemd. This was because
        I needed to use efibootmgr to reorder the boot order.
        */
        loader = {
            limine = {
                enable = true;
                efiSupport = true;
                resolution = "1920x1080x32";
                enableEditor = false;
                maxGenerations = 10;
            };

            # Disable alternative bootloaders
            systemd-boot.enable = lib.mkForce false;
            grub.enable         = lib.mkForce false;

            # Hopefully nixos should sort out bootup procedures
            # if not then refer to efibootmgr
            # > nix shell nixpkgs#efibootmgr
            efi.canTouchEfiVariables = true;
            timeout = 5;
        };
    };


    ##======================================================##
    ## File System Configuration                            ##
    ##      This creates the /etc/fstab configuration which ##
    ##      tells linux what to mount on boot. My desktop   ##
    ##      is quite old and so it still has the good old   ##
    ##      OS on the SSD, data on the HDD setup so I have  ##
    ##      my /home mounted seperately.                    ##
    ##======================================================##
    # This is where my OS (and /nix/store) is stored
    fileSystems."/" = {
        device = "/dev/sda7";
        # EXT4 because it is reliable
        fsType = "ext4";
    };

    # /dev/sdb is my HDD.
    # BTRFS is used because that is what was used on an older install
    fileSystems."/home" = {
        device = "/dev/sdb4";
        fsType = "btrfs";
    };

    # /boot does not techinically need to be mounted by I like to mount it
    # so I can view it for debugging.
    fileSystems."/boot" = {
        device = "/dev/sdb2";
        fsType = "vfat";
    };

    swapDevices = [{
        device = "/dev/sda5";
    }];



    ##=========================================================##
    ## Nvidia Setup                                            ##
    ##      Nvidia cards on linux has come a long way so there ##
    ##      is not much setup required anymore.                ##
    ##=========================================================##
    hardware = {
        nvidia = {
            enabled = true;
            modesetting.enable = true;
        };

        # OpenGL settings
        graphics = {
            enable = true;
        };
    };

}

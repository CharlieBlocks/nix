/*

Configurations Parts
-> Hosts; Hosts are per-system configuration.
    - m1 # macbooks
    - d1 # desktops
    - v1 # Virtual machine
-> Users; Users are applied to each system seperatly. Each user will select
optional modules to be part of the system. Plus some secrets setup
    - matt; My personal config
        -> IDE configuration
        -> Web browser
        -> etc...
    - void; A impersonal guest style configuration
-> Modules
    Enabled based on config.modules = { } per user
    - shell
        -> alacritty
            -> tmux
        -> ghostty
        -> nushell
            -> zellij
        -> zsh
            -> zoxdie, etc...
    - ide
        -> vscode
        -> zed

sudo nixos-rebuild switch --flake .#m1-matt

*/

/*
Hello reader!

This is the nix configuration that I use across my linux desktops
and apple laptops, it is intended to work with nixos and nix-darwin.
It currently uses home-manager for configuration.

Theming is done using tinted-theming and base16/base24 themes. These are
mostly hardcoded into config files as I find that this is the most easily
customisable method of configuring themes.

Note that due to some of the intraciacies of system configuration this configuration
will be very verbose on comments. I find that, despite nix the package
manager being declarative, nix the language is a little harder to read at a glance.
*/
{
    description = "My Nix configuration";

    /*
    Inputs that we will need for the whole system.
    */
    inputs = {

        /*
        Obviously we need nixpkgs. I prefer the unstable branch currently.
        */
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        /*
        flake-parts has become the standard way for constructing flake modules.
        */
        # flake-parts.url = "github:hercules-ci/flake-parts";

        /*
        For MacOS we cannot use nixpkgs.lib.nixosSystem. Instead we need
        to pull it in as a seperate flake.
        */
        nix-darwin = {
            url =  "github:nix-darwin/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        /*
        home-manager is an requirement for this configuration. It helps us
        seperate programs by user and has many handy builtin program configurations.
        */
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        /*
        On macOS some programs are only obtainable with homebrew. Obviously we do
        not wish to break our declaritve state so instead I choose this implemention
        of homebrew in nix.

        brew-nix provides the interaction with homebrew and brew-api is the source
        for packages.
        */
        brew-nix = {
            url = "github:BatteredBunny/brew-nix";
            inputs.brew-api.follows = "brew-api";
            inputs.nix-darwin.follows = "nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        brew-api = {
            url = "github:BatteredBunny/brew-api";
            flake = false;
        };


        niri = {
            url = "github:sodiboo/niri-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zsh-patina = {
            url = "github:michel-kraemer/zsh-patina";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        /*
        Finally, season to taste.

        tinted-theming is a collection of base16/base24/tinted8 colour themes
        that we can apply to our program configurations.

        Themes can be viewed using the tinted gallery at:
            https://tinted-theming.github.io/tinted-gallery/
        */
        tt-schemes = {
            url = "github:tinted-theming/schemes";
            flake = false;
        };
        base16 = {
            url = "github:SenchoPens/base16.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };



        ly-anim = {
       	url = "git+https://codeberg.org/fairyglade/ly-community.git";
       	flake = false;
        };

    };

    /*
    Just incase you or I have hit our heads hard recently and can't remember how a nix flake
    works here is a quick rundown.

    This file exports an object that follows the flake schema. This schema requires that
    we provide:
        - inputs; This is the attrset above which specifys which external flakes to pull in.
        - outputs; This is this function. It accepts the evalulated results from our inputs
            and returns an attrset with our configuration in.
            NixOS or nix-darwin will read the result of outputs and apply them to our system.

    The syntax directly below this comment specifys that outputs should be a function
    that accepts any amount of args, including self, and we can access these args using the
    inputs attrset.
    */
    outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
    let
        /*
        This is the list of physical devices that this nix configuration will
        be deployed on. I use shorthand names because it makes typing out the rebuild
        command easier. An example system would be

                xl1

        This is expanded to
            <architecture><os><instance>

        Here are a few examples:
            xl1 - x86_64, linux, machine 1
            Am1 - aarch64, macos (darwin), machine 1
            al4 - armv7 (32bit), linux, machine 4 (NOTE: This could be a raspberry pi)

        I currently have the following hosts:
            Am1 - My shared personal and work macbook
            xl1 - My personal dual-booting desktop computer.
        */
        hosts = [
            "Am1"
            "xl1"
        ];


        /*
        All hosts have some basic configuration. They configure the hardware and machine behaviour.
        Users can be applied to any host and configure what programs are available on the machine.

        I should note that with nix-darwin there is a little fuzziness between hosts and users since
        configuration is more tightly intertwined.

        I keep two users; 'matt' is my personal account, configured for development. 'void' is a anonymous
        account to be used in one-off cases where we just want a working system. Useful for VMs, cloud providers
        or small-board computers (pi, jetson, etc...).
        */
        users = [
            "matt"
            "void"
        ];


        /*
        Here we set the overlays to be applied to nixpkgs.

        Overlays are additions made to the nixpkgs flake to allow us to add or override functionality.
        In this case we are adding packages that are not included by default in NixOS, nix-darwin or
        home-manager.

        This is not techinically the nix way to overlay packages. That would be done using
        `import nixpkgs { inherit system; overlays = [ ... ] }`; However for the purposes of NixOS and
        nix-darwin this is the done way.

        (https://wiki.nixos.org/wiki/Overlays)
        */
        # Currently breaks nixpkgs
        # nixpkgs.overlays = [
        #     inputs.brew-nix.overlays.default
        # ];


        forOs =
        # Args
            os: # The operating system identifier (l or m)
            hosts: # The hosts to filter
        # Code
            builtins.filter
                # Function
                (x: if (builtins.elemAt (nixpkgs.lib.strings.stringToCharacters x) 1) == os then true else false )
                hosts;



        /*
        eachSystem will iterate over every possible system configuration using
        hosts and users. For each system a callback will be invoked passing both
        the host and system. The returned attrset will have the results from the
        callback mapped to ${host}-${user}.
        */
        eachSystem =
        # Args
            hosts:
            users:
            callback:
            # Code
            builtins.listToAttrs (
                map
                    (args: { name = "${args.hosts}-${args.users}"; value = callback { host = args.hosts; user = args.users; }; })
                    (nixpkgs.lib.attrsets.cartesianProduct {
                        hosts = hosts;
                        users = users;
                    })
            );

    in
    {
        nixosConfigurations = eachSystem
            (forOs "l" hosts) # Filter hosts to just linux hosts
            users
            /* Callback that creates a nixos system from the given host and user params */
            ({ host, user }:
            let
                hostfile = if builtins.pathExists ./hosts/${host} then
                    ./hosts/${host}
                else
                    (abort "Oh no! I think I've lost the hosts file for ${host}. I was looking at ./hosts/${host} while building the system ${host}-${user}.");

                userfile = if builtins.pathExists ./users/${user} then
                    ./users/${user}
                else
                    (abort "Uh oh! I think I've lost the configuration file for the user ${user} I was looking at ./users/${user} while building the system ${host}-${user}.");

            in
                # Returns a new nixosSystem
                nixpkgs.lib.nixosSystem {
                    /*
                    specialArgs is an attrset that is provided to all module functions.
                    By including inputs here we allow our other modules to access the flake
                    inputs.
                    */
                    specialArgs = { inherit inputs; };
                    modules = [
                        /*
                        As a note for people about to navigate to hosts
                        I split the hardware configuration from the host configuration
                        then import both in the default.nix (which is imported by this statement).
                        */
                        hostfile

                        /*
                        This is a patch until I reorder where home-manager is declared so users
                        can declare themselves on the nixos system. Currently once in the user files
                        we have no control over the nixos configuration.
                        */
                        ./users/patch.nix

                        /*
                        User configuration is performed using home-manager. As such we add home-manager to
                        our NixOS system here.
                        */
                        home-manager.nixosModules.home-manager {
             			    home-manager.useGlobalPkgs = true;
             			    home-manager.useUserPackages = true;
                            home-manager.extraSpecialArgs = { inherit (self) inputs outputs; };
                            home-manager.users.${user} = import userfile;
                            home-manager.modules = [
                                # This will initialise the base16 home-manager module
                                # which allows us to access the base16 colours from the home-manager
                                # config.
                                inputs.base16.homeManagerModule
                            ];
                            # home-manager.modules = [
                            #     /*
                            #     Users are esentially just a config file for our modules. However we keep them
                            #     in their own directories to allow maximum flexibility when using the default.nix
                            #     imports.
                            #     */
                            #     userfile
                            # ];
                            /*
                            These are modules that are shared between users
                            */
                            home-manager.sharedModules = [
                                inputs.niri.homeModules.niri
                            ];
                        }
                    ];
                }
            );


        darwinConfigurations = eachSystem
            (forOs "m" hosts) # Filter hosts to just macos hosts
            users
            ({ host, user }:
            let
                hostfile = if builtins.pathExists ./hosts/${host} then
                    ./hosts/${host}
                else
                    (abort "Oh no! I think I've lost the hosts file for ${host}. I was looking at ./hosts/${host} while building the system ${host}-${user}.");

                userfile = if builtins.pathExists ./users/${user} then
                    ./users/${user}
                else
                    (abort "Uh oh! I think I've lost the configuration file for the user ${user} I was looking at ./users/${user} while building the system ${host}-${user}.");
            in
                /*
                I would like to look at merging darwin.lib into nixpkgs.lib however I
                don't belive this can be done with overlays
                */
                nix-darwin.lib.darwinSystem {
                    /*
                    specialArgs is an attrset that is provided to all module functions.
                    By including inputs here we allow our other modules to access the flake
                    inputs.
                    */
                    specialArgs = { inherit inputs; };
                    modules = [
                        /*
                        As a note for people about to navigate to hosts
                        I split the hardware configuration from the host configuration
                        then import both in the default.nix (which is imported by this statement).
                        */
                        hostfile

                        /*
                        User configuration is performed using home-manager. As such we add home-manager to
                        our NixOS system here.
                        */
                        home-manager.darwinModules.home-manager {
                            extraSpecialArgs = { inherit (self) inputs outputs; };
                            modules = [
                                /*
                                Users are esentially just a config file for our modules. However we keep them
                                in their own directories to allow maximum flexibility when using the default.nix
                                imports.
                                */
                                userfile
                            ];
                        }
                    ];
                }
            );
    };
}

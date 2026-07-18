{ pkgs, lib, inputs, ... }:
let
in

{
    home.stateVersion = "26.05";

    imports = [
        # These are home-manager configurations that are applied
        # to all users. This is mostly home-manager's own configuration
        # as well as secrets management.
        ../../home/global

        # ext are optional modules that are included. Each module contains
        # one or more programs which have been customised to my liking.
        # These are then enabled using the `ext.<>` config which will
        # install them onto the system.
        ../../home/ext
    ];


    /*
    https://home-manager-options.extranix.com/?query=fonts.fontconfig&release=release-26.05
    Here we configure the fonts that will be installed onto the system. We have
    a standard, non-monospaced font and my prefered JetBrainsMono (I know, I'm a basic bitch)
    monospaced font.

    I don't like serif fonts so we don't set a default
    */
    home.packages = with pkgs; [
        atkinson-hyperlegible-next
        atkinson-hyperlegible-mono # Might try this over JetBrains
        nerd-fonts.jetbrains-mono
    ];
    fonts.fontconfig = {
        enable = true;
        antialiasing = true;

        # This may appear a little weird on OLED monitors but nixos
        # does not include a grayscale option. May be something to look
        # into.
        subpixelRendering = "rgb";

        defaultFonts = {
            sansSerif = [ "Atkinson Hyperlegible Next" ];
            monospace = [ "JetBrainsMono" "Atkinson Hyperlegible Mono" ];
        };
    };


    /*
    Sets the colour scheme that will be used by programs. These are
    injected into the dot files, usually into a 'nix' theme, to style
    the app. Yes, I am aware that stylix exists but I prefer this method.
    */
    scheme = "${inputs.tt-schemes}/base24/eldritch.yaml";


    /*
    The apps config is provided by our /home/ext module
    */
    apps = {

        /*
        niri is the window manager that I am using, largly because
        I have seen a lot of people say that it has a better new-user
        experience than hyprland.
        */
        niri.enable = !pkgs.stdenv.buildPlatform.isDarwin;

        /*
        On macOS I still use a window manager in the form of Aerospace.
        This is more similar to Hyprland than Niri. I would warn that
        it does have some quirks, paticuarly while multithreaded actions
        have not been implemented which causes non-responsive windows -
        *cough*Unity*cough* - to bung up navigation.
        */
        # aerospace.enable = pkgs.stdenv.buildPlatform.isDarwin;

        /*
        I am a long term alacritty user and have never had a problem with it.
        I am possibly interested in using ghostty so I can have img preview
        in yazi but alacritty feels much less bloated.
        */
        alacritty = {
            enable = true;

            # zsh or nushell
            shell = "zsh";

            /*
            Origionally I was a tmux user however I have never gotton on
            with the config or some of the more dated nuances. As such I've
            been trying out zellij as an alternative.
            */
            emulator = "tmux";

            /*
            Extra programs that need shell integration.
            direnv is always enabled.
            */
            extras = {
                zoxide = true;
            };
        };


        # zed = {
        #     enable = true;
        #     extensions = [ ];
        # };


        /*
        Me and VSCode have a few trust issues - *glances at extensions* - so
        my config neuters it quite a bit. However I keep it around as it can
        be useful when Zed fails.

        Also, does anyone else feel like Zed has been getting progressivly less
        responsive to user feedback. Stuff like changing tab size has been an
        issue for years now.
        */
        # vscode = {
        #     enable = true;
        # };


        /*
        On MacOS I still use safari but I use firefox/librefox as my backup and so I can
        check for gecko engine differences.

        Chrome is installed despite my best wishes because, again, I need to test
        against chromium.
        */
        # librefox.enable = true;
        # firefox.enable = true;
        # chrome.enable = true;


        /*
        A collection of cli tools. Most of these are CLIs.
        I don't install or configure tools like cargo or python
        as that is the job of devshells
        */
        # cli = {
        #     az = {
        #         enable = true;

        #         # TODO: Credentials
        #         username = "";

        #         # https://discourse.nixos.org/t/how-can-we-use-the-azure-cli-extensions-packages/45474/5
        #         extensions = [];
        #     };

        #     /* git is included in global but not configured for the user */
        #     git = {
        #         enable = true;
        #         # name = "Matthew Tindley";
        #         # email = "matthewjtindley@gmail.com";
        #     };

        #     /*
        #     Since I moved from windows to macos I started using podman.
        #     I much prefer it to docker and have finally managed to phase
        #     all docker usage out of my workflow. The last sticking point
        #     was cross compilation but nix solved that!
        #     */
        #     podman.enable = true;
        #     docker.enable = false; # Technically not CLI but that is a docker problem

        #     /**/
        #     ssh = {
        #         enable = true;
        #         # Some config
        #         # auto-generate keys?
        #     };


        #     /*
        #     Wireguard has become my goto for VPN configurations. Much easier
        #     to deploy than OpenVPN and significantly lighter.
        #     */
        #     wireguard = {
        #         enable = true;
        #         profiles = [];
        #     };


        #     # common.enable = true
        #     # - nix-search-tv
        #     # - wget
        #     # - rsync
        #     # - zip
        #     # - unzip

        # };

    };

}

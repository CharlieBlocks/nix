{ pkgs, base16, tt-schemes, ... }:
let
    user = "matthewtindley";
in

{
    imports = [
        base16.homeManagerModule

        # Themes can be found at
        # https://github.com/tinted-theming/schemes/tree/spec-0.11
        # and viewed from https://tinted-theming.github.io/tinted-gallery/
        { scheme = "${tt-schemes}/base24/eldritch.yaml"; }

        # Programs
        (import ../modules/nushell.nix)
        (import ../modules/ghostty.nix)
        (import ../modules/direnv.nix)
        (import ../modules/zoxide.nix) # And fzf
        (import ../modules/zellij.nix)

        # (import ../modules/brew.nix)
    ];

    home = {
        username = "${user}";
        # homeDirectory = /Users/${user};

        # Core packages
        packages = [
            pkgs.coreutils
            pkgs.vim
        ];

        sessionVariables = {
            EDITOR = "vim";
        };
        sessionPath = [
            "/run/current-system/sw/bin"
        ];

        stateVersion = "25.11";
    };

    programs = {
        home-manager.enable = true;
        bash.enable = true;
    };
}

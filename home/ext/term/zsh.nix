{ config, pkgs, user, lib, inputs, ... }: {

    imports = [
        ./starship.nix
    ];

    home.packages = [ pkgs.zsh pkgs.starship ];
    programs.zsh = {
        enable = true;
        package = pkgs.zsh;
        defaultKeymap = null;

        plugins = [
            {
                name = "zsh-patina";
                src = inputs.zsh-patina;
            }
        ];

        envExtra = '''';

        shellAliases = {

        };

        history = {
            append = true;
            expireDuplicatesFirst = true;
            path = "$HOME/.zsh_history";
            share = false;
            size = 100000;
        };

        setOptions = [
            "HIST_IGNORE_ALL_DUPS"
        ];

        enableCompletion = true;
        autosuggestion = {
            enable = true;
            # highlight = "";
            strategy = [
                "completion"
                "history"
            ];
        };

    };

}

{ config, lib, ... }: {

    options.apps.cli.git = {
        enable = lib.mkEnableOption "Enable Git";
        name = lib.mkOption {
            name = "Author Name";
            type = lib.types.str;
        };
        email = lib.mkOption {
            name = "Author Email";
            type = lib.types.str;
        };
    };


    config = {
        programs.git = lib.mkIf config.options.apps.cli.git.enable {
            enable = true;
            lfs.enable = true;

            config = {
                user = {
                    name = config.apps.cli.git.name;
                    email = config.apps.cli.git.email;
                };

                init.defaultBranch = "main";

            };

            settings = {
                init.defaultBranch = "main";
                filter.lfs = {
                    required = true;
                    clean = "git-lfs clean -- %f";
                    smudge = "git-lfs smudge -- %f";
                    process = "git-lfs filter-process";
                };
                alias = {
                    last = "log -1 HEAD";
                };
            };
        };
    };

}

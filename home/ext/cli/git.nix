{ config, lib, ... }: {

    options.apps.cli.git = {
        enable = lib.mkEnableOption "Enable Git";
        name = lib.mkOption {
            description = "Author Name";
            type = lib.types.str;
        };
        email = lib.mkOption {
            description = "Author Email";
            type = lib.types.str;
        };
    };


    config = {
        programs.git = lib.mkIf config.apps.cli.git.enable {
            enable = true;
            lfs.enable = true;

            settings = {
                init.defaultBranch = "main";
                # filter.lfs = {
                #     required = true;
                #     clean = "git-lfs clean -- %f";
                #     smudge = "git-lfs smudge -- %f";
                #     process = "git-lfs filter-process";
                # };
                alias = {
                    last = "log -1 HEAD";
                };
            };
        };
    };

}

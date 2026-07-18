{ pkgs, ... }: {
    users.users."matt" = {
        isNormalUser = true;
        extraGroups = [ "networkManager" "wheel" ];
        shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
}

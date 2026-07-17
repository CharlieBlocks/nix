{ ... }: {
    users.users."matt" = {
        isNormalUser = true;
        extraGroups = [ "networkManager" "wheel" ];
    };
}

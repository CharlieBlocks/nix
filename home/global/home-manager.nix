{ config, pkgs }: {

    # Enable home-manager
    programs.home-manager.enable = true;

    # Sets the version of home-manager that we are using.
    home.stateVersion = "26.05";

    /*
    TODO: Setup brew for darwin

    */

}

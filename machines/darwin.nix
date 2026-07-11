{ self, name, user, nixpkgs, darwin, home-manager, modules ? [], base16, tt-schemes }:

let
  # config = ./configuration { nixpkgs, user, systemPackages };

  # See https://mynixos.com/nix-darwin/options/system
  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
    primaryUser = "root";

    # https://github.com/nix-darwin/nix-darwin/issues/518#issuecomment-2691433665
    activationScripts.postActivation.text = ''
        # Following line should allow us to avoid a logout/login cycle when changing settings
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };
in

{
  # This will create a new darwin system configuration
  # with the specified name.
  "${name}" = darwin.lib.darwinSystem {
    # The system configuration as deinfed above
    system = system;

    # An attribute set that is passed to all functions
    # specified in `modules`.
   specialArgs = { user = user; };

    # A list of sub-modules to execute to build the system
    # configuration. We specify some darwin-specific modules
    # such as ./configuration then concatenate (`++`) with generic
    # modules specified by the caller
    modules = [
        ./configuration.nix

        home-manager.darwinModules.home-manager {
            home-manager.backupFileExtension = ".bkp";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { user = "matthewtindley"; inherit base16 tt-schemes; };
            home-manager.users.matthewtindley = ../users/matthewtindley.nix;
            users.users.matthewtindley.home = "/Users/matthewtindley";
        }
    ] ++ modules;
  };
}

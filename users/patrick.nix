{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users.patrick = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
	
  security.sudo.extraRules = [
    { users = [ "patrick" ];
      commands = [
        { command = "ALL" ;
	  options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
	}
      ];
    }
  ];

  ### OPENSSH ###
  services.openssh.enable = true;
#  services.openssh.settings.PermitRootLogin = "yes";
	
  services.openssh.hostKeys = [ #THIS IS NOT GENERATING A NEW SSH KEY
    {
      path = "/home/patrick/.ssh/id_ed25519";
      type = "ed25519";
    }
  ];

  home-manager.users.patrick = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "18.09";
    
      programs.git = {
        enable = true;
        userName  = "Monty";
        userEmail = "21371673+pmontgo33@users.noreply.github.com";
        extraConfig = {
          receive.denyCurrentBranch = "updateInstead"; 
        };
      };
  };
}

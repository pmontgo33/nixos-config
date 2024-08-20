{ pkgs, lib, modulesPath, ... }: 
{
  imports = [
    ./samba.nix
    ../modules/home-manager_patrick.nix
  ];
	
  ### INSTALL PACKAGES ###
  environment.systemPackages = with pkgs; [
    vim
    tmux
    git
    fail2ban
		nix-ld
  ];

  ### SET TIMEZONE ###
  time.timeZone = "America/New_York";

  ### ADD AND SETUP USERS ###
  /*
  Generate ssh key for user
  ssh-keygen
  */
  users.users.patrick = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
	
  security.sudo.extraRules= [
    { users = [ "patrick" ];
      commands = [
        { command = "ALL" ;
	  options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
	}
      ];
    }
  ];

  system.activationScripts = {
      sambaUserSetup = {
        text = ''
           PATH=$PATH:${lib.makeBinPath [ pkgs.samba ]}
           pdbedit -i smbpasswd:./smbpasswd -e tdbsam:/var/lib/samba/private/passdb.tdb                                                                       
            '';
        deps = [ ];
      };
    };

  ### OPENSSH ###
  services.openssh.enable = true;
#  services.openssh.settings.PermitRootLogin = "yes";
	
  ### SETUP PACKAGES ###
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
	
  programs.git = {
    enable = true;
#    userName  = "Monty";
#    userEmail = "21371673+pmontgo33@users.noreply.github.com";
  };
	
  ### ENABLE REMOTE VSCODE TO CONNECT ###
	programs.nix-ld.enable = true;
  /*
  Create symlinks for nixos configuration files so user can edit
  mkdir ~/etc
  sudo mv /etc/nixos ~/etc/
  sudo chown -R $(id -un):users ~/etc/nixos
  sudo ln -s ~/etc/nixos /etc/
  */


}

{ pkgs, modulesPath, ... }: 
{
  imports = [
    ./samba.nix
    ../users/root.nix
    ../users/patrick.nix
  ];
	
  nix.settings.experimental-features = "nix-command flakes";

  ### INSTALL PACKAGES ###
  environment.systemPackages = with pkgs; [
    vim
    tmux
    git
    crowdsec
		nix-ld
    just
  ];

  ### SET TIMEZONE ###
  time.timeZone = "America/New_York";

  ### OPENSSH ###
  services.openssh.enable = true;

  ### SETUP PACKAGES ###
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
	
  programs.git.enable = true;
	
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

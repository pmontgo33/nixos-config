{ pkgs, modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./base/base_config.nix
  ];
	
  environment.systemPackages = with pkgs; [
		
  ];

  system.stateVersion = "24.05";
}

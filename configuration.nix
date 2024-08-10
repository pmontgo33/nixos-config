{ pkgs, modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./hosts/minimal/minimal.nix
  ];
	
  environment.systemPackages = with pkgs; [
		
  ];

  system.stateVersion = "24.05";
}

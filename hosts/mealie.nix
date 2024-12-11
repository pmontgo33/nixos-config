{ pkgs, ... }: 

{
  imports = [
    ../base/base_config.nix
  ];
	
  environment.systemPackages = with pkgs; [
		mealie
  ];
  
  services.mealie.enable = true;

  networking.firewall.allowedTCPPorts = [ 9000 ];
}

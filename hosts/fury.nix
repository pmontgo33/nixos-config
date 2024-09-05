{ pkgs, ... }: 

{
  imports = [
    ../base/base_config.nix
    ../modules/tailscale.nix
  ];
	
  environment.systemPackages = with pkgs; [
		ansible

  ];
  
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
  users.users.patrick.extraGroups = [ "docker" ];
}

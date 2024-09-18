{ pkgs, ... }: 

{
  imports = [
    ../base/base_config.nix
    ../modules/tailscale.nix
    ../modules/podman.nix
    ../containers/code-server.nix
  ];
	
  environment.systemPackages = with pkgs; [
		ansible
    ansible-lint

  ];

  #   virtualisation = {
  #   docker = {
  #     enable = true;
  #     autoPrune = {
  #       enable = true;
  #       dates = "weekly";
  #     };
  #   };
  # };
  # users.users.patrick.extraGroups = [ "docker" ];

  #virtualisation.oci-containers.backend = "podman"; #moved to podman.nix
  


}
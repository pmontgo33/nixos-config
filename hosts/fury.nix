{ pkgs, ... }: 

{
  imports = [
    ../base/base_config.nix
    ../modules/tailscale.nix
    ../modules/podman.nix
    # ../containers/code-server.nix
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

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    code-server = {
      image = "lscr.io/linuxserver/code-server:latest";
      autoStart = true;
      extraOptions = [ "--pull=newer" ];
      ports = [ "8443:8443" ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Etc/UTC";
        PASSWORD = "password";
        SUDO_PASSWORD = "password";
      };
      volumes = [
        "/home/patrick/containers/code-server:/config"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];


}

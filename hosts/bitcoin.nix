{ config, pkgs, ... }:

{
  imports = [
    ../modules/secrets.nix
  ];
  # Enable the Nix-Bitcoin service
  # services.nixbitcoin = {
  #   enable = true;
  #   dataDir = "/var/lib/nixbitcoin";
  #   rpcUser = "myuser";
  #   rpcPassword = "mypassword";
  #   extraConfig = ''
  #     server=1
  #     txindex=1
  #     zmqpubrawblock=tcp://127.0.0.1:28332
  #     zmqpubrawtx=tcp://127.0.0.1:28333
  #   '';
  # };

  # Enable the Lightning node service
  services.lightning = {
    enable = true;
    dataDir = "/var/lib/lightning";
    network = "mainnet";
    # bitcoindRpcUrl = "http://myuser:mypassword@127.0.0.1:8332";
    extraConfig = ''
      log-level=debug
      log-file=/var/log/lightning.log
      bind-addr=0.0.0.0:9735
      announce-addr=${secrets.lightning-domain}
    '';
  };

  # # Enable the Liquid node service
  # services.liquid = {
  #   enable = true;
  #   dataDir = "/var/lib/liquid";
  #   rpcUser = "myuser";
  #   rpcPassword = "mypassword";
  #   extraConfig = ''
  #     server=1
  #     txindex=1
  #     zmqpubrawblock=tcp://127.0.0.1:28334
  #     zmqpubrawtx=tcp://127.0.0.1:28335
  #   '';
  # };

  # Open the necessary ports
  networking.firewall.allowedTCPPorts = [ 8333 9735 7041 ];

  # Automatically start the services on system boot
  systemd.services.nixbitcoin.wantedBy = [ "multi-user.target" ];
  systemd.services.lightning.wantedBy = [ "multi-user.target" ];
  systemd.services.liquid.wantedBy = [ "multi-user.target" ];
}
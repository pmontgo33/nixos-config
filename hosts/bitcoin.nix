{ config, pkgs, ... }:

let
  # Your custom domain
  domain = config.sops.secrets.bitcoin-domain.path;
in
{
  imports = [
    (fetchTarball {
      url = "https://github.com/fort-nix/nix-bitcoin/releases/download/v0.0.119/nix-bitcoin-0.0.119.tar.gz";
      sha256 = "1q78ajffi79jl4nml02j2g6aa283xg1p44kpnq7fd78by62axwzk"; # Replace with actual hash
    } + "/modules/presets/secure.nix")
    ../base/base_config.nix
    ../modules/tailscale.nix
  ];
  
  # Enable Bitcoin Core (if running full node)
  services.bitcoind.enable = true;
  services.bitcoind.network = "main";
  services.bitcoind.dataDir = "/var/lib/bitcoind";
  
  # Enable LND with custom domain settings
  services.lnd = {
    enable = true;
    dataDir = "/var/lib/lnd";
    
    extraConfig = ''
      [Application Options]
      debuglevel=info
      tlsextraip=0.0.0.0
      tlsextradomain=lnd.${domain}
      externalip=lnd.${domain}
      
      [Bitcoin]
      bitcoin.active=1
      bitcoin.mainnet=1
      bitcoin.node=bitcoind
      
      [tor]
      tor.active=true
      tor.v3=true
    '';
  };
  
  # Firewall: open web ports
  networking.firewall.allowedTCPPorts = [ 80 443 8333 9735 3000 3002 ];
  
  # Storage configuration remains the same
  fileSystems."/var/lib/bitcoind" = {
    device = "/dev/disk/by-label/bitcoin";
    fsType = "ext4";
    options = [ "noatime" ];
  };
  
  fileSystems."/var/lib/lnd" = {
    device = "/dev/disk/by-label/lightning";
    fsType = "ext4";
    options = [ "noatime" ];
  };
}
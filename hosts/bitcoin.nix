{ config, pkgs, ... }:

let
  # Import the nixbitcoin modules
  nixbitcoin = import (builtins.fetchTarball {
    url = "https://github.com/fort-nix/nix-bitcoin/releases/download/v0.0.118/nix-bitcoin-0.0.118.tar.gz";
    sha256 = "3a3f5775a4ff3a51f611c70c15459f4e277f0e79303f7bef4f4b6da49da660b1"; # Replace with actual hash
  }) { inherit pkgs; };
  
  imports = [
    ../modules/secrets.nix
  ];
  # Your custom domain
  domain = config.sops.secrets.bitcoin-domain.path;
in
{
  imports = [
    nixbitcoin.modules.presets.secure
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
{ config, pkgs, ... }:

{
  imports = [
    (fetchTarball {
      url = "https://github.com/fort-nix/nix-bitcoin/releases/download/v0.0.119/nix-bitcoin-0.0.119.tar.gz";
      sha256 = "1s3c5yjl4n39m6qsd4vb246zfqr8xlgdw3xzgy6vj21qxa33xi5d"; # Replace with actual hash
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
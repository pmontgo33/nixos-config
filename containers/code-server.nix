{
systemd.tmpfiles.rules = [
  "d /home/patrick/containers/code-server 0755 patrick users"
];

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

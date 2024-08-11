/* 
For installation on LXC, add these lines to /etc/pve/lxc/ID.conf:
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
*/

{
  services.tailscale.enable = true;
}
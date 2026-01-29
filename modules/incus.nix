{ config, pkgs, ... }:
{
  virtualisation.incus.enable = true;
  virtualisation.incus.ui.enable = true;

  networking.nftables.enable = true;
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  networking.firewall.interfaces.incusbr0.allowedTCPPorts = [
    53
    67
  ];
  networking.firewall.interfaces.incusbr0.allowedUDPPorts = [
    53
    67
  ];

  users.users.ouroboros.extraGroups = [ "incus-admin" ];

  virtualisation.incus.preseed = {
    networks = [
      {
        config = {
          "ipv4.address" = "10.0.100.1/24";
          "ipv4.nat" = "true";
        };
        name = "incusbr0";
        type = "bridge";
      }
    ];
    profiles = [
      {
        devices = {
          eth0 = {
            name = "eth0";
            network = "incusbr0";
            type = "nic";
          };
          root = {
            path = "/";
            pool = "default";
            size = "35GiB";
            type = "disk";
          };
        };
        name = "default";
      }
    ];
    storage_pools = [
      {
        config = {
          source = "/extras/incus/storage-pools/default";
        };
        driver = "dir";
        name = "new";
      }
    ];
  };

}

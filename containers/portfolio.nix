{ ... }:
{
  containers.portfolio = {
    autoStart = false;
    privateNetwork = true;
    hostAddress = "10.231.136.1";
    localAddress = "10.231.136.2";

    bindMounts = {
      "/srv/site" = {
        hostPath = "/srv/web/portfolio";
        isReadOnly = true;
      };
    };

    config =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        services.nginx = {
          enable = true;
          virtualHosts.localhost = {
            root = "/srv/site";
            locations."/" = {
              tryFiles = "$uri $uri/ =404";
            };
          };

        };
        system.stateVersion = "25.11";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
  };
}

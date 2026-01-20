{
  lib,
  config,
  pkgs,
  ...
}:
{
  networking.firewall.checkReversePath = "loose";

  networking.wg-quick.interfaces =
    let
      server_ip = "bos-298-wg.whiskergalaxy.com";
      server_port = 65142;
    in
    {
      windscribe = {
        autostart = false;
        address = [ "100.94.83.255" ];

        listenPort = server_port;

        dns = [ "10.255.255.3" ];

        privateKeyFile = "/root/wireguard-keys/windscribe.key";

        peers = [
          {
            publicKey = "5yBJlSpfxd8Hq4+X4ZD60MYc6tosaMh5inQwA18XCCk=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "${server_ip}:${builtins.toString server_port}";
            presharedKeyFile = "/root/wireguard-keys/windscribe-preshared.key";
            persistentKeepalive = 25;
          }
        ];

      };
      kyiv = {
        autostart = false;
        address = [ "100.94.83.255" ];

        listenPort = 443;

        dns = [ "10.255.255.3" ];

        privateKeyFile = "/root/wireguard-keys/kyiv.key";

        peers = [
          {
            publicKey = "xd+b0SNB38ILyN8mfY3d7w7zLggbq4CkkxqPavP2OUk=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "kbp-383-wg.whiskergalaxy.com:443";
            presharedKeyFile = "/root/wireguard-keys/kyiv-preshared.key";
            persistentKeepalive = 25;
          }
        ];

      };
      oslo = {
        autostart = false;
        address = [ "100.82.206.130" ];

        listenPort = 443;

        dns = [ "10.255.255.3" ];

        privateKeyFile = "/root/wireguard-keys/oslo.key";

        peers = [
          {
            publicKey = "y+Kvlfz0z8DF17hVvEezMml3SH3OaB2l5l09DPdQNCk=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "osl-169-wg.whiskergalaxy.com:443";
            presharedKeyFile = "/root/wireguard-keys/oslo-preshared.key";
            persistentKeepalive = 25;
          }
        ];
      };

      berlin = {
        autostart = false;
        address = [ "100.88.175.29" ];

        listenPort = 443;

        dns = [ "10.255.255.3" ];

        privateKeyFile = "/root/wireguard-keys/berlin.key";

        peers = [
          {
            publicKey = "b287iER/CtdRo/0ulDSq6lDywY7l8fVlwFWibsDWgUY=";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "ber-449-wg.whiskergalaxy.com:443";
            presharedKeyFile = "/root/wireguard-keys/berlin-preshared.key";
            persistentKeepalive = 25;
          }
        ];
      };
    };

}

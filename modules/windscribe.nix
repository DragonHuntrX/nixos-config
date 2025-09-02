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
      wg0 = {
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
    };

}

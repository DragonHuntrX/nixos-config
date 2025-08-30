{
  lib,
  config,
  pkgs,
  ...
}:
{
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

        privateKeyFile = [ /root/wireguard-keys/windscribe.key ];

        peers = [
          {
            publicKey = "5yBJlSpfxd8Hq4+X4ZD60MYc6tosaMh5inQwA18XCCk=";
            allowedIps = [ "0.0.0.0/0" ];
            endpoint = "${server_ip}:${server_port}";
            preshared = [/root/wireguard-keys/windscribe-preshared.key];
          }
        ];

      };
    };

}

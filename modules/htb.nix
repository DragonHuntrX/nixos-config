{
  config,
  lib,
  pkgs,
  ...
}:
{

  networking.hosts = {
    "10.10.11.221" = [ "2million.htb" ];
    "10.10.11.74" = [ "artificial.htb" ];
  };
}

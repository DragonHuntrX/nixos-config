{
  pkgs,
  config,
  lib,
  ...
}:
{
  networking.nat = {
    enable = true;
    # Use "ve-*" when using nftables instead of iptables
    internalInterfaces = [ "ve-+" ];
    externalInterface = "wlp0s20f3";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
    internalIPs = [ "10.0.0.0/8" ];
  };
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  stablePkgs = inputs.nixpkgs-stable.legacyPackages.x86_64-linux;
in
{
  services.tailscale.enable = true;
  services.tailscale.package = stablePkgs.tailscale;
  services.tailscale.useRoutingFeatures = "client";
  networking.firewall.checkReversePath = "loose";

  # environment.systemPackages = [
  #   inputs.nixpkgs-stable.tailscale
  # ];
}

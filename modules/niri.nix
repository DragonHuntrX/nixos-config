{ config, pkgs, ... }:
{
  programs.niri.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.systemPackages = with pkgs; [
    niri
    fuzzel
    alacritty

  ];

}

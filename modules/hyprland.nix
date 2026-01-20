{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    upower.enable = true;
    power-profiles-daemon.enable = true;
    blueman.enable = true;
    libinput.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # # file manager
    # kdePackages.dolphin

    # term
    alacritty

    # app launcher
    inputs.hyprlauncher.packages.${system}.hyprlauncher

    # wallpaper
    hyprpaper

    # screenshot
    hyprshot

    # theming
    nwg-look

    egl-wayland

    hyprlock
    hyprland-qt-support

    hyprpanel

    hyprpolkitagent
    brightnessctl

    xdg-desktop-portal-hyprland

  ];

}

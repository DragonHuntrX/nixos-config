{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./rofi.nix
  ];

  xdg.portal.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "qimgv.desktop";
      "image/jpg" = "qimgv.desktop";
      "video/mkv" = "qimgv.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  home.packages = with pkgs; [
    dunst
    libnotify
    hyprpaper
    networkmanagerapplet

    file
    cairo
    libglvnd
    hyprlang
    hyprutils
    hyprgraphics
    hyprwayland-scanner

    hypridle

    hyprshot

    hyprls

    wl-clipboard
    rofi
    lm_sensors

    thunar

    # aylurs-gtk-shell-git
    wireplumber
    libgtop
    bluez
    # bluez-utils
    networkmanager
    dart-sass
    wl-clipboard
    upower
    gvfs
    gtksourceview3
    # libsoup3

    libsoup_3
    btop
    hyprsunset
    power-profiles-daemon
  ];

  # programs.waybar = {
  #   enable = true;
  # };

  programs.hyprpanel = {
    # Configure and theme almost all options from the GUI.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {

      wallpaper.image = "/home/ouroboros/Pictures/wallpaper.png";
      # Configure bar layouts for monitors.
      # See 'https://hyprpanel.com/configuration/panel.html'.
      # Default: null
      layout = {
        bar.layouts = {
          "0" = {
            left = [
              "dashboard"
              "workspaces"
            ];
            middle = [ "media" ];
            right = [
              "volume"
              "systray"
              "notifications"
            ];
          };
        };
      };

      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.launcher.icon = "󰣑";
      bar.clock.format = "%a %b %d  %I:%M %p";

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      theme.bar.transparent = true;
      theme.bar.menus.menu = {
        dashboard.scaling = 80;
        clock.scaling = 80;
        notifications.scaling = 80;
        media.scaling = 80;
        volume.scaling = 80;
        network.scaling = 80;
        battery.scaling = 80;
        bluetooth.scaling = 80;
      };
      theme.notification.scaling = 80;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };

}

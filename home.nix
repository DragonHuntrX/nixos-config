{
  config,
  lib,
  pkgs,
  user,
  nixpkgs-stable,
  ...
}:
let
  nixpkgs.overlays = [ (import ./overlays/1password.nix) ];
in
{
  imports = [
    # ./firefox.nix
    ./home-manager/zsh.nix
    ./home-manager/helix.nix
    ./home-manager/tmux.nix
    ./home-manager/ssh.nix
    ./home-manager/hypr.nix
    ./home-manager/tidal.nix
  ];

  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          wallpaper-slideshow.extensionUuid
        ];
      };
    };
  };

  home.packages = with pkgs; [
    # Security Tools
    nmap
    wordlists
    cyberchef
    checksec
    rustscan
    nuclei
    binwalk

    # Extra
    bc

    # Math utils
    julia-bin

    # Cli utilites
    magic-wormhole
    direnv
    xsel
    transmission_4
    units
    file
    unzip
    openconnect
    glow
    yazi
    bacon
    codex
    sox

    # Containerization
    podman

    # Gui utilities
    nixpkgs-stable.darktable
    discord
    _1password-cli
    _1password-gui
    obsidian
    signal-desktop-bin
    tor-browser
    zathura
    obs-studio
    gimp
    qimgv

    # Games
    ferium
    prismlauncher

    # steam
    # mesa

    # Privacy
    tor
    torsocks

  ];

  programs.alacritty = {
    enable = true;
    settings = {

      font = {
        normal = {
          family = "FiraCode Nerd Font";
        };
      };
      general = {
        import = [ pkgs.alacritty-theme.tokyo_night ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "DragonHuntrX";
    userEmail = "John@Devost.net";
    extraConfig = {
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAB6BFObLg09Fddo6I0ZazK1/LI+ukT90TcnB2xPsdZY";
      };
      gpg = {
        format = "ssh";
      };
      commit = {
        sign = true;
        gpgsign = true;
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      pull.rebase = false;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    systemd.variables = [ "--all" ];

  };

  home.stateVersion = "24.11";
  home.sessionVariables = {
    BROWSER = "${lib.getExe pkgs.firefox}";
    EDITOR = "${lib.getExe pkgs.helix}";
    NIXOS_OZONE_WL = 1;
    OBSIDIAN_USE_WAYLAND = 1;
  };

  programs.home-manager.enable = true;

}

{
  config,
  lib,
  pkgs,
  user,
  nixpkgs-stable,
  ...
}:
let
  onePassPath = "~/.1password/agent.sock";

in
{

  imports = [
    # ./firefox.nix
    ./home-manager/zsh.nix
    ./home-manager/helix.nix
    ./home-manager/tmux.nix
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
    wireshark
    checksec

    # Extra
    bc

    # Math utils
    julia

    # Cli utilites
    magic-wormhole
    direnv
    xsel
    transmission_4
    units
    file

    # Gui utilities
    nixpkgs-stable.darktable
    discord
    _1password-cli
    _1password-gui
    obsidian
    signal-desktop-bin
    tor-browser
    zathura

    # Games
    ferium
    prismlauncher

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
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
      Host git
        Hostname github.com
        User git
        IdentityFile ~/.ssh/git.pub
      Host jdsgit
        Hostname github.com
        User git
        IdentityFile ~/.ssh/jdsgit.pub
      Host csportal
        Hostname portal.cs.virginia.edu
        User chk6aa
        IdentityFile ~/.ssh/csportal.pub
      Host stoicdrive
        Hostname stoic-driveway
        User root
        IdentityFile ~/.ssh/stoicdrive.pub
      Host testbench
        Hostname 192.168.1.83
        User testbencher
        IdentityFile ~/.ssh/testbench.pub
      Host pwnc
        Hostname pwn.college
        User hacker
        IdentityFile ~/.ssh/pwnc.pub
    '';
  };

  xsession.windowManager.i3.config.startup.alacritty = {
    always = true;
    command = "alacritty";
  };

  home.stateVersion = "24.11";
  home.sessionVariables = {
    BROWSER = "${lib.getExe pkgs.firefox}";
    EDITOR = "${lib.getExe pkgs.helix}";
  };

  programs.home-manager.enable = true;

}

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
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [
    # Quick dev tools

    # Security Tools
    nmap
    cyberchef
    wireshark
    checksec

    # Extra
    cowsay
    pay-respects
    bc

    # Math utils
    julia

    # Cli utilites
    magic-wormhole
    direnv
    xsel
    transmission_4
    openvpn
    proxmark3
    proxmark3-rrg

    # Gui utilities
    nixpkgs-stable.darktable
    discord
    _1password-cli
    _1password-gui
    obsidian
    signal-desktop-bin
    tor-browser

    # Games
    ferium
    prismlauncher

    typos-lsp

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

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
      {
        name = "python";
        auto-format = true;
        formatter.command = "${pkgs.python3Packages.black}/bin/black";
      }
      {
        name = "markdown";
        language-servers = [ "typos" ];
      }
    ];
    languages.language-server = {
      typos = {
        command = "${pkgs.typos-lsp}/bin/typos-lsp";
        environment = {
          "RUST_LOG" = "error";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      # tmux-nova
      tokyo-night-tmux
      # nord
      # onedark-theme
      # catppuccin
      weather
    ];
    extraConfig = ''
      set -sg escape-time 0
      set -g mouse on
      set -g default-terminal "alacritty"

      set -g @tokyo-night-tmux_show_hostname 1
      set -g @tokyo-night-tmux_show_path 1
      set -g @tokyo-night-tmux_path_format relative
      set -g @tokyo-night-tmux_show_netspeed 1
    '';
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

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        # "tmux"
        "direnv"
      ];
      theme = "af-magic";
    };
    shellAliases = {
      cbr = "cargo build -r";
      crr = "cargo run -r";
      flakers-init = "nix flake init -t github:DragonHuntrX/nix-templates#rust-stable";
      rb = "sudo nixos-rebuild switch";
      econf = "hx ~/nixos-config/";
      factor = "~/tools/math-utils factor";
    };
    sessionVariables = {
      EDITOR = "hx";
    };

    initContent =
      let
        pre = lib.mkBefore ''
          math () {
            julia -E "$*";
          }
        '';
        post = lib.mkAfter ''
          export ZSH_TMUX_AUTOSTART=true
        '';
      in
      lib.mkMerge [
        pre
        post
      ];

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

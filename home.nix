{
  config,
  lib,
  pkgs,
  ...
}:
let
  onePassPath = "~/.1password/agent.sock";

in
{
  home.username = "ouroboros";
  home.homeDirectory = "/home/ouroboros";

  home.packages = with pkgs; [
    # Graphics tools
    darktable
    gimp

    # Security tools
    nmap

    # Cli tools
    thefuck
    direnv
    xsel

    # Utilities
    discord
    _1password-cli
    _1password-gui
    obsidian
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
    ];
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
      set -g default-terminal "alacritty"
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
        "thefuck"
        "direnv"
      ];
      theme = "af-magic";
    };
    shellAliases = {
      cbr = "cargo build -r";
      crr = "cargo run -r";
      flakers-init = "nix flake init -t github:DragonHuntrX/nix-templates#rust-stable";
      rb = "sudo nixos-rebuild switch";
    };
    sessionVariables = {
      EDITOR = "hx";
    };
    initExtra = '''';
    initExtraFirst = ''
      export ZSH_TMUX_AUTOSTART=true
    '';

  };

  xsession.windowManager.i3.config.startup.alacritty = {
    always = true;
    command = "alacritty";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}

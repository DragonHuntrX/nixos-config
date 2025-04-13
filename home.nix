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
    nmap
    cowsay
    gnome-terminal
    direnv
    thefuck
    _1password-cli
    _1password-gui
    virtualenv
  ];

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
    ];
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      tokyo-night-tmux
    ];
    extraConfig = ''
      set -sg escape-time 0
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
        "tmux"
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

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}

{ config, pkgs, ...}:

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
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
    }];
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
        sign = "true";
      };
      "gpg \"ssh\"" = {
        program = "/opt/1Password/op-ssh-sign";
      };
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "direnv"];
      theme = "af-magic";
    };
    shellAliases = {
      cbr = "cargo build -r";
      crr = "cargo run -r";
      flakers-init = "nix flake init -t github:DragonHuntrX/nix-templates#rust-stable";
    };
    sessionVariables = {
      EDITOR = "hx";
    };
    initExtra = ''
    '';
  };


  home.stateVersion = "24.11";


  programs.home-manager.enable = true;

}

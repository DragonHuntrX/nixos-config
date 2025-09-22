{
  pkgs,
  lib,
  config,
  ...
}:
{

  home.packages = with pkgs; [
    # Language servers
    vhdl-ls
    typos-lsp
    marksman
    markdown-oxide
  ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
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
      }
      # {
      #   name = "markdown";
      #   language-servers = [ "typos" ];
      # }
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
}

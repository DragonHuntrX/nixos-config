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
    texlab
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
      {
        name = "latex";
        auto-format = true;
        formatter = {
          command = lib.getExe pkgs.tex-fmt;
          args = [ "--stdin" ];
        };
        language-servers = [
          "texlab"
          "typos"
        ];
      }
      {
        name = "spellcheck";
        language-servers = [ "typos" ];
        scope = "text.spellcheck";
        file-types = [ ];

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
      julia = {
        command = "julia";
        args = [
          "--project=@LanguageServer"
          "--startup-file=no"
          "--history-file=no"
          "-e"
          "using LanguageServer; runserver()"
        ];
      };
    };
  };
}

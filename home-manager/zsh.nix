{
  lib,
  pkgs,
  config,
  ...
}:
{
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
      update = "rb";
      econf = "hx ~/nixos-config/";

      factor = "~/tools/math-utils factor";
    };
    sessionVariables = {
      EDITOR = "hx";
      # LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    initContent =
      let
        pre = lib.mkBefore ''
          math () {
            julia -E "$*";
          }

          fe() {
            local target="flake.nix"
            local dir="$PWD"

            while [[ "$dir" != "/" ]]; do
              if [[ -f "$dir/$target" ]]; then
                ''${EDITOR:-vim} "$dir/$target"
                return
              fi
              dir="$(dirname "$dir")"
            done

            ''${EDITOR:-vim} "./flake.nix"
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
}

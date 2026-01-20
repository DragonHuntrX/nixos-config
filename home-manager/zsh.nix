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

      nr = "nix run";
      da = "direnv allow";

      ts = "tailscale";

      factor = "~/tools/math-utils factor";
    };
    sessionVariables = {
      EDITOR = "hx";
      # LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    initContent =
      let
        pre = lib.mkBefore ''

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

          grab() {
            mv $1 .
          }

          function y() {
          	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          	yazi "$@" --cwd-file="$tmp"
          	IFS= read -r -d '''''' cwd < "$tmp"
          	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          	rm -f -- "$tmp"
          }

          vpn() {
            if systemctl is-active wg-quick-windscribe.service | grep -q 'inactive'; then
              sudo systemctl start wg-quick-windscribe.service
            else
              sudo systemctl stop wg-quick-windscribe.service
            fi
          }
        '';
        post = lib.mkAfter ''
          autoload zmv
          ${lib.getExe pkgs.neofetch}
        '';
      in
      lib.mkMerge [
        pre
        post
      ];

  };
}

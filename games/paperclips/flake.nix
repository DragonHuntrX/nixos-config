{
  description = "Universal Paperclips (Electron) packaged for NixOS via upstream AppImage";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # or 25.05 when it lands for you
  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          pname = "universal-paperclips-electron";
          version = "0.0.8"; # latest as of 2024-01-10
          # Grab the AppImage from the repo Releases page
          src = pkgs.fetchurl {
            url = "https://github.com/Alex313031/universal-paperclips-electron/releases/download/v${version}/universal-paperclips_${version}_x64.AppImage";
            # Fill this after running: nix-prefetch-url --unpack <url>
            sha256 = "sha256-oCCGNgEL537neRo6sDAj1VfBO/IB1gb6ale6l52PQNA=";
          };

          appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };

          desktopItem = pkgs.makeDesktopItem {
            name = pname;
            desktopName = "Universal Paperclips";
            comment = "Paperclip maximizer (Electron port)";
            exec = "${pname} %U";
            categories = [ "Game" ];
            # We’ll install an icon from inside the AppImage below.
          };
        in
        {
          default = pkgs.appimageTools.wrapType2 {
            inherit pname version src;
            # Electron apps usually Just Work as type2 AppImages
            extraInstallCommands = ''
              # Desktop file
              install -Dm644 ${desktopItem}/share/applications/${pname}.desktop \
                $out/share/applications/${pname}.desktop

              # Try to find and install a reasonable icon from the AppImage contents
              # This copies the largest PNG icon it finds.
              icon_src=$(find ${appimageContents} -type f -iname "*icon*.png" -o -iname "*paperclip*.png" | sort | tail -n1 || true)
              if [ -n "$icon_src" ]; then
                install -Dm644 "$icon_src" $out/share/pixmaps/${pname}.png
                # Patch .desktop to reference the installed icon
                substituteInPlace $out/share/applications/${pname}.desktop \
                  --replace "Icon=${pname}" "Icon=${pname}"
              fi
            '';
          };
        }
      );

      nixosModules.universal-paperclips =
        {
          lib,
          pkgs,
          config,
          ...
        }:
        let
          cfg = config.programs.universal-paperclips;
          wrappedBin =
            let
              flags = lib.concatStringsSep " " cfg.extraArgs;
            in
            pkgs.writeShellScriptBin "universal-paperclips-electron" ''
              exec ${cfg.package}/bin/universal-paperclips-electron ${flags} "$@"
            '';
        in
        {
          options.programs.universal-paperclips = {
            enable = lib.mkEnableOption "Universal Paperclips (Electron)";

            package = lib.mkOption {

              type = lib.types.package;
              default = self.packages.${pkgs.system}.universal-paperclips-electron;
              description = ''
                Which package to install. Defaults to the AppImage-based package
                exported by this flake. You can override with a custom derivation.
              '';
            };

            extraArgs = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [
                "--disable-gpu"
                "--ozone-platform=x11"
              ];
              description = ''
                Extra command-line arguments passed to the launcher. If non-empty,
                a wrapper script is placed on PATH that forwards to the real binary.
              '';
            };
          };

          config = lib.mkIf cfg.enable {
            environment.systemPackages = [
              (if cfg.extraArgs == [ ] then cfg.package else wrappedBin)
            ];
          };

        };

    };
}

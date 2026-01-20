{
  lib,
  config,
  pkgs,
  paperclips,
  ...
}:
let
  cfg = config.programs.games;
in
{
  options.programs.games = {
    enable = lib.mkEnableOption "Games toggle";
    paperclips = {
      enable = lib.mkEnableOption "Universal Paperclips Electron Wrapper";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.steam
      pkgs.mesa

    ];
  };

}

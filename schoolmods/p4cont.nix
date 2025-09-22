{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.containers.enable = true;

  containers.p4dev = {
    autoStart = false;
    ephemeral = false;
    privateNetwork = false;

    privateUsers = null;

    bindMounts = {
      "/work" = {
        hostPath = "/home/ouroboros/school/f25/compnets/p4";
        isReadOnly = false;
      };
    };

    config =
      { pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [
          p4
          zsh
          helix
        ];
        users.users.ouroboros = {
          isNormalUser = true;
          uuid = 1000;
          extraGroups = [ "wheel" ];
          home = "/home/ouroboros";
          createHome = true;
        };

        services.openssh.enable = true;
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enableCompletion = true;
        security.sudo.enable = true;

      };

  };
}

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    jack2
    qjackctl
    zlib.dev
    ghc
    cabal-install
    gcc
    stdenv.cc.cc

    supercollider-with-sc3-plugins

  ];
}

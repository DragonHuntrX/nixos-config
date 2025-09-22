{ ... }:
let
  paperclips = builtins.getFlake (toString ./games/paperclips);
in
{
  home.packages = [
    paperclips.packages
  ];

}

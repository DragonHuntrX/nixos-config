{
  config,
  pkgs,
  waveforms,
  ...
}:
{
  imports = [
    waveforms.nixosModule
  ];

  environment.systemPackages = with pkgs; [
    kicad
  ];
}

{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "1password-gui"
      "1password"
      "1password-cli"
      "opengl"
      "cuda"
      "cuda_cudart"
      "cudann"
      "libcublas"
      "cuda_cccl"
      "cuda_nvcc"
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "vscode"
      "obsidian"
      "discord"

      "waveforms"
      "adept2-runtime"
    ];
}

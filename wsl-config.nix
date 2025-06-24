{ pkgs, lib, config, ...}:
let
in {
  
  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    openssl
    helix
    nil
    nixd
    git
    zsh
  ];

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # Enable 1Password CLI and GUI
  programs._1password = {
    enable = true;
  };
  fonts.packages = with pkgs; [
    nerdfonts
  ];

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
      "obsidian"
      "discord"
    ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  
}

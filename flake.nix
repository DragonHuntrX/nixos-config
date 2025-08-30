{
  description = "My little Nix Flake";
  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      alacritty-theme,
      nixpkgs-stable,
      ...
    }@inputs:
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations.infinity = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {

            nixpkgs.overlays = [ alacritty-theme.overlays.default ];
            networking.hostName = "infinity"; # Define your hostname.

            programs.nix-ld.enable = true;
          }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          ./docker.nix
          ./hardware-configs/infinity.nix
          ./gpusetup.nix

          ./modules/windscribe.nix

          home-manager.nixosModules.home-manager
          {
            # home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ouroboros = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              user = "ouroboros";
              nixpkgs-stable = nixpkgs-stable.legacyPackages.x86_64-linux;
            };
          }
        ];
      };
      nixosConfigurations.infinitum = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.11";
            wsl.enable = true;
          }
          {
            nixpkgs.overlays = [ alacritty-theme.overlays.default ];
            networking.hostName = "infinitum"; # Define your hostname.
          }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./wsl-config.nix
          # ./hardware-configs/infinity.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nixos = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            home-manager.extraSpecialArgs = {
              user = "nixos";
            };
          }
        ];
      };
    };
}

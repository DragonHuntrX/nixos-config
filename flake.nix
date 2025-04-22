{
  description = "My little Nix Flake";
  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      alacritty-theme,
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
          }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          ./firefox.nix
          ./gpusetup.nix
          ./hardware-configs/infinity.nix
          home-manager.nixosModules.home-manager
          {
            # home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ouroboros = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
      nixosConfigurations.infinitum = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {

            networking.hostName = "infinity"; # Define your hostname.
          }
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          ./hardware-configs/infinity.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ouroboros = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
}

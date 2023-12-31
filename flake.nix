{
  description = "Michael's flake for NixOS and Nix-on-Droid";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-on-droid = {
        url = "github:nix-community/nix-on-droid/release-23.05";
        inputs = {
            nixpkgs.follows = "nixpkgs";
            home-manager.follows = "home-manager";
        };
      };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hosts.url = "github:StevenBlack/hosts";
      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      stylix.url = "github:danth/stylix";
      firefox-addons = {
        url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
        inputs.nixpkgs.follows = "nixpkgs";
      };

  };

  outputs = { self, nixpkgs, nix-on-droid, home-manager, hosts, nixvim, stylix, firefox-addons }: {

      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [ ./phone/configuration.nix ];
        extraSpecialArgs = { inherit nixpkgs home-manager nixvim stylix; };
      };

      nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                ./desktop/configuration.nix
                ./settings
                ./pkgs/nixvim
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.michael.imports = [ ./home.nix ./pkgs/sway ./pkgs/browsers ];
                  home-manager.users.michael.home.stateVersion = "23.11";
                  home-manager.extraSpecialArgs = { inherit firefox-addons stylix; };
                }
                nixvim.nixosModules.nixvim
                stylix.nixosModules.stylix
              ];
          };
          laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
              modules = [
                ./laptop/configuration.nix
                ./pkgs/nixvim
                ./settings
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.michael.imports = [ ./home.nix ./pkgs/sway ./pkgs/beets.nix ./pkgs/browsers ];
                  home-manager.users.michael.home.stateVersion = "23.05";
                  home-manager.extraSpecialArgs = { inherit firefox-addons stylix; };
                }
                nixvim.nixosModules.nixvim
                stylix.nixosModules.stylix
                hosts.nixosModule {
                  networking.stevenBlackHosts = {
                    enable = true;
                    blockFakenews = true;
                    blockGambling = true;
                  };
                }
              ];
            };
      };
  };
}

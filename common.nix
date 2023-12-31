{ pkgs, config, lib, ... }:
{
  nix = {
      settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
      gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 7d";
        };
    };
      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "electron-25.9.0" ]; # Discord

      };
}

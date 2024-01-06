{ config, lib, pkgs, ... }:
{
  imports = [ ./user.nix ./zsh.nix ./network.nix ./bluetooth.nix ./security.nix ./locale.nix ./boot.nix ./xdg.nix ./stylix ];
  environment.systemPackages = with pkgs; [ nix-init ];
  nix = {

    nixPath = ["nixpkgs=${pkgs.path}"];

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

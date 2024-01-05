{ config, pkgs, lib, ... }:

{
  stylix = {
    image = ./wallpaper.jpeg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      size = 32;
    };
    fonts = {
      serif = config.stylix.fonts.sansSerif;
      sansSerif = {
        package = pkgs.nerdfonts.override { fonts = [ "Lilex" ]; };
        name = "Lilex Nerd Font";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "Lilex" ]; };
        name = "Lilex Nerd Font Mono";
      };
      emoji = {
        package = pkgs.openmoji-black;
        name = "OpenMoji Black";
      };
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 10;
        terminal = 12;
      };
    };
    opacity = {
      applications = 0.9;
      desktop = 0.8;
      terminal = 0.9;
    };
  };
}

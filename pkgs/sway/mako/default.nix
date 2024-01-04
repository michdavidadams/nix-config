{ config, lib, pkgs, ... }:
{
  stylix.targets.mako.enable = true;

  home.packages = with pkgs; [ libnotify ];

  services.mako = {
    enable = true;
    anchor = "top-right";
    maxIconSize = 20;
    maxVisible = 5;
  };
}

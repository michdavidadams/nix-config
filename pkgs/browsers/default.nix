{ config, lib, pkgs, ... }:
{
  imports = [
    ./chromium.nix
    ./firefox.nix
  ];
}

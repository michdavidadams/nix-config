{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ nix-init (callPackage /home/michael/nix-config/pkgs/a2ln-server {}) ];
}

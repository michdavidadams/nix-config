{ config, lib, pkgs, ... }:
{
  users.users.michael.shell = pkgs.zsh;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

}

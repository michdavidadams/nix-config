{ config, lib, pkgs, ... }:
{
  users.users.michael.shell = pkgs.zsh;
  user.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

}

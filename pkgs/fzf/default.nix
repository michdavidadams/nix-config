{ config, lib, pkgs, ... }:
let
  fzf-mpd = pkgs.writeShellScriptBin {
    name = "fzf-mpd";
    source = ./mpd.sh;
  
  fzf-pass = pkgs.writeShellScriptBin {
    name = "fzf-pass";
    source = ./pass.sh;
  };

in
{
  home.packages = with pkgs; [ fzf-mpd fzf-pass ];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f";
      };
}

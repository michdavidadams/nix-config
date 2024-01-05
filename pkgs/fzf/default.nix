{ config, lib, pkgs, ... }:
let
  fzf-mpd = pkgs.writeScriptBin "fzf-mpd" (builtins.readFile ./mpd.sh); 
  fzf-pass = pkgs.writeScriptBin "fzf-pass" (builtins.readFile ./pass.sh);

in
  {
    stylix.targets.fzf.enable = true;
  home.packages = with pkgs; [ fzf-mpd fzf-pass ];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f";
  };
}

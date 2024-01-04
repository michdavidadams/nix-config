{ config, lib, pkgs, ... }:
{
  stylix = {
    opacity.terminal = 0.9;
    targets.foot.enable = true;
  };

  home.packages = with pkgs; [ xdg-open ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        title = "foot";
        locked-title = false;
      };
      url = {
        launch = "xdg-open \${url}";
        protocols = [ "https" "http" "file" ];
      };
    };
  };
}

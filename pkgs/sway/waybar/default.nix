{ config, pkgs, lib, ... }:
{
  stylix.targets.waybar = {
    enable = true;
    enableCenterBackColors = false;
    enableLeftBackColors = true;
    enableRightBackColors = true;
  };

      programs.waybar = {
      enable = true;
      settings = [
        {
            layer = "top";
            position = "top";
            margin = "8";
            spacing = "6";
            modules-left = [ "sway/workspaces" "tray" ];
            modules-center = [ "sway/window" ];
            modules-right = [ "mpd" "wireplumber" "backlight" "network" "bluetooth" "battery" "clock" ];
            "backlight" = {
              format = "{icon} {percent}%";
              format-icons = [ "" "" "" "" "" "" "" "" "" "" "" "" "" ];
            };
            "bluetooth" = {
              format = "";
              format-disabled = "";
              format-connected = " {num_connections}";
            };
            "clock" = {
              format = " {:%a, %b %Od, %I:%M}";
            };
            "mpd" = {
              format = "{stateIcon} {albumArtist} - {title}";
              format-stopped = "";
              format-paused = "{stateIcon} {songPosition}/{queueLength}";
              state-icons = {
                "paused" = "";
                "playing" = "";
              };
            };
            "network" = {
              format-ethernet = "";
              format-wifi = "";
              format-disconnected = "";
            };
            "tray" = {
              icon-size = 20;
              show-passive-icons = true;
              spacing = 10;
            };
            "wireplumber" = {
              format = "{icon} {volume}%";
              format-icons = [ "" "" "" ];
            };
          }
        ];
        systemd.enable = true;
      };

}

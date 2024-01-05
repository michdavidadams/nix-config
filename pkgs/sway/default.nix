{ config, pkgs, lib, ... }:
let
  modifier = "Mod4";
  fzf-launcher = pkgs.writeScriptBin "fzf-launcher" (builtins.readFile ../fzf/launcher.sh);
  fzf-power-menu = pkgs.writeScriptBin "fzf-power-menu" (builtins.readFile ../fzf/power-menu.sh);

in
  {
    imports = [ ./browsers ./waybar ./foot ./mako ./gammastep ./swayidle ./swaylock ];
    home.packages = with pkgs; [ wl-clipboard wdisplays glib xdg-utils grim slurp j4-dmenu-desktop ytfzf pam_gnupg fzf-launcher fzf-power-menu ];

    stylix = {
      opacity = {
        applications = 0.9;
        desktop = 0.3;
        popups = 0.7;
      };
      targets = {
        gtk.enable = true;
        sway.enable = true;
        zathura.enable = true;
      };
    };
    services.pass-secret-service.enable = true;
    services.mpd = {
        enable = true;
        extraConfig = ''
        audio_output {
          type "pipewire"
          name "Speakers"
        }
        '';
        musicDirectory = "/home/michael/Music";
      };

    gtk.enable = true;

    programs.zsh.initExtra = ''
    [ "$(tty)" = "/dev/tty1" ] && exec sway
    '';

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      config = {
        bars = [ { command = "\${pkgs.waybar}/bin/waybar"; } ];
        gaps = {
          horizontal = 4;
          inner = 15;
          outer = 0;
        };
        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${pkgs.foot}/bin/foot";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec foot -a launcher -e fzf-launcher";
          "${modifier}+m" = "exec foot -a music -e fzf-mpd";
          "${modifier}+Shift+e" = "exec foot -a fzf-power-menu -e fzf-power-menu";
        };
        menu = "j4-dmenu-desktop --dmenu=fzf";
        modifier = "Mod4";
          startup = [
          { command = "systemctl --user restart waybar"; always = true; }
        ];
        window = {
          border = 4;
          commands = [
            { command = "floating enable, sticky enable, resize set 25 ppt 40 ppt, border pixel 4, blur enable"; criteria.app_id = "music"; }
            { command = "floating enable, sticky enable, resize set 25 ppt 40 ppt, border pixel 4, blur enable"; criteria.app_id = "launcher"; }
            { command = "floating enable, sticky enable, resize set 25 ppt 40 ppt, border pixel 4, blur enable"; criteria.app_id = "power-menu"; }
            { command = "blur enable"; criteria = { app_id = "foot"; }; }
          ];
          titlebar = false;
        };
        floating = {
          criteria = [ { title = "Steam Settings"; } { title = "Friends List"; } ];
        };
      };
      extraConfig = ''
      bindsym XF86AudioLowerVolume exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-'
      bindsym XF86AudioMute exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
      bindsym XF86AudioNext exec 'mpc next'
      bindsym XF86AudioPause exec 'mpc toggle'
      bindsym XF86AudioPlay exec 'mpc toggle'
      bindsym XF86AudioPrev exec 'mpc prev'
      bindsym XF86AudioRaiseVolume exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+'
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10
      bindsym Print exec grim  -g "$(slurp)" /home/michael/Pictures/$(date +'%H-%M-%S.png')
      shadows enable
      corner_radius 15
      layer_effects "waybar" blur enable; corner_radius 15; shadows enable
      '';
      extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      '';
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      xwayland = true;
    };

    programs.pistol.enable = true;
    programs.zathura.enable = true;
      programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ wlrobs obs-source-record obs-pipewire-audio-capture obs-vkcapture ];
  };

    services.cliphist.enable = true;
    services.udiskie.enable = true;

}

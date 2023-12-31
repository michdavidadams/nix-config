{ config, pkgs, lib, ... }:
let
  modifier = "Mod4";
  fzf-launcher = pkgs.writeShellScriptBin "fzf-launcher" ''
  j4-dmenu-desktop --dmenu=fzf --no-generic --no-exec | xargs swaymsg exec --
  '';

in
{
    home.packages = with pkgs; [ wl-clipboard wdisplays glib xdg-utils grim slurp j4-dmenu-desktop libnotify ytfzf pam_gnupg mpc-cli fzf-launcher jq papirus-icon-theme ];

    stylix = {
      opacity = {
        applications = 0.9;
        desktop = 0.3;
        popups = 0.7;
        terminal = 0.9;
      };
      targets = {
        fuzzel.enable = true;
        fzf.enable = true;
        gtk.enable = true;
        mako.enable = true;
        nixvim = {
          enable = true;
          transparent_bg.main = true;
          transparent_bg.sign_column = true;
        };
        sway.enable = true;
        swaylock.enable = true;
        waybar = {
          enable = true;
          enableCenterBackColors = true;
          enableLeftBackColors = true;
          enableRightBackColors = true;
        };
        xresources.enable = true;
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
      swaynag.enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      xwayland = true;
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
              format-paused = "{stateIcon}";
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
    programs.swaylock = {
      enable = true;
      settings = {
        indicator-idle-visible = false;
        show-failed-attempts = false;
      };
    };
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
        { event = "lock"; command = "lock"; }
      ];
      timeouts = [
        { timeout = 2700; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      ];
    };
    programs.foot = {
      enable = true;
    };

    programs.pistol.enable = true;
    programs.zathura.enable = true;

    services.gammastep = {
      enable = true;
      latitude = "34.2";
      longitude = "-85.1";
      provider = "geoclue2";
      temperature.day = 5000;
      temperature.night = 3000;
    };
    services.mako = {
      enable = true;
      anchor = "top-right";
    };
    services.cliphist.enable = true;
    services.udiskie.enable = true;

    services.kdeconnect.enable = true;

}

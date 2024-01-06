{ lib, config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  hardware.enableAllFirmware = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;

    programs.npm.enable = true;

    services.udisks2.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };
    services.dbus.enable = true;
    programs.light.enable = true;
    programs.dconf.enable = true;
 
  environment.systemPackages = with pkgs; [ libreoffice duckstation pcsx2 discord r2modman steamguard-cli libheif ff2mpv mpv gimp-with-plugins lutgen ffmpeg ];

  # Networking
  networking.hostName = "michael-laptop";

  # GPU Acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ intel-compute-runtime intel-media-driver ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.syncthing = {
      enable = true;
      user = "michael";
      dataDir = "/home/michael";
      configDir = "/home/michael/.config/syncthing";
  };

    # Gaming
    programs.java.enable = true;
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
            extraEnv = {
                RADV_TEX_ANISO = 16;
            };
            extraLibraries = p: with p; [ atk ];
        };
      };

    # audio, music, mpd
    services.mpdscribble = {
        enable = true;
        endpoints = {
            "last.fm" = {
                passwordFile = "/home/michael/.keys/lastfm_password";
                username = "michdavidadams";
            };
        };
      };

  system.stateVersion = "23.05";
}

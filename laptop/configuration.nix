{ lib, config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../common.nix ];
  hardware.enableAllFirmware = true;
  services.fstrim.enable = true;

users.users.michael = {
    isNormalUser = true;
    home = "/home/michael";
    name = "michael";
    description = "Michael Adams";
    extraGroups = [ "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    programs.npm = {
      enable = true;
    };

    security.rtkit.enable = true;
    security.pam.loginLimits = [ { domain = "@users"; item = "rtprio"; type = "-"; value = 1; } ];
    services.udisks2.enable = true;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };
    services.dbus.enable = true;
    programs.light.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;
    security.pam.services.swaylock = {};
    security.pam.services.login.gnupg = {
      enable = true;
      storeOnly = true;
    };
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      configPackages = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
    };

      xdg.sounds.enable = true;
      time.timeZone = "America/New_York";
      location = {
      provider = "geoclue2";
      latitude = 34.2;
      longitude = -85.1;
    };
  # Bootloader
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  
  environment.systemPackages = with pkgs; [ libreoffice duckstation pcsx2 discord r2modman steamguard-cli libheif ff2mpv mpv gimp-with-plugins inkscape ];

  # Networking
  networking = {
    hostName = "michael-laptop";
    domain = "michdavidadams.com";
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    wireless = {
        enable = true;
        scanOnLowSignal = false;
        environmentFile = "/home/michael/.keys/wireless.env";
        networks = {
            MiSky.psk = "@PASS_MISKY@";
            Adams.psk = "@PASS_ADAMS@";
        };
    };
    nat.enableIPv6 = true;
    useDHCP = true;
    firewall = {
        enable = true;
        allowPing = true;
        allowedUDPPorts = [ 13579 ];
    };
  };

  # Enable bluetooth
  hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

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

{ config, pkgs, lib, ... }:
let
  "lights-off" = pkgs.writeShellScriptBin "lights-off.sh" ''
  exec mosquitto_pub -t 'zigbee2mqtt/living_room/set' -m '{ "state": "OFF" }'
  '';

in
{
  imports = [ ./hardware-configuration.nix ../common.nix ];
  hardware.facetimehd.enable = true;
  hardware.enableAllFirmware = true;

    users.users.michael = {
    isNormalUser = true;
    home = "/home/michael";
    name = "michael";
    description = "Michael Adams";
    extraGroups = [ "wheel" "audio" "video" "mosquitto" ];
    shell = pkgs.zsh;
  };

    programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  security.rtkit.enable = true;
    security.pam.loginLimits = [ { domain = "@users"; item = "rtprio"; type = "-"; value = 1; } ];

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
    hardware.opengl.enable = true;
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

      environment.systemPackages = with pkgs; [
     mosquitto lights-off
  ];

  # Smart home
  systemd.services = {
    "lights-off" = {
      description = "Turn off lights before shutdown";
      after = [ "final.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.lights-off}/bin/lights-off.sh";
      };
      wantedBy = [ "final.target" ];
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "me@michdavidadams.com";
    certs = { "michael-desktop.michdavidadams.com" = {
      dnsProvider = "googledomains";
      credentialFiles = {
        "GOOGLE_DOMAINS_ACCESS_TOKEN_FILE" = "/home/michael/.keys/googledomainstoken.txt";
      }; };
    };
  };
  users.groups.acme.members = [ "mosquitto" "michael" ];
  services.mosquitto = {
      enable = true;
      listeners = [
        { port = 8883; acl = [ "topic readwrite #" "pattern readwrite #" ]; settings = { allow_anonymous = true; require_certificate = false; cafile = "/var/lib/acme/michael-desktop.michdavidadams.com/chain.pem"; certfile = "/var/lib/acme/michael-desktop.michdavidadams.com/cert.pem"; keyfile = "/var/lib/acme/michael-desktop.michdavidadams.com/key.pem"; }; }
        { port = 1883; acl = [ "topic readwrite #" "pattern readwrite #" ]; omitPasswordAuth = true; settings.allow_anonymous = true; }
      ];
  };
  services.zigbee2mqtt = {
      enable = true;
      settings = {
        availability = false;
        devices = {
          "0x00178801062517fa" = {
            friendly_name = "desk_left";
          };
          "0x0017880106283c92" = {
            friendly_name = "desk_right";
          };
          "0x001788010405ca48" = {
            friendly_name = "lightstrip";
          };
        };
        groups = {
          "1" = {
            devices = [ "desk_left" "desk_right" "lightstrip" ];
            friendly_name = "living_room";
          };
        };
          permit_join = true;
          mqtt = {
              server = "mqtt://localhost:1883";
              base_topic = "zigbee2mqtt";
              reject_unauthorized = false;
          };
          frontend = true;
          serial = {
              port = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20230804152402-if00";
          };
      };
    };

    services.syncthing = { enable = true; user = "michael"; dataDir = "/home/michael"; configDir = "/home/michael/.config/syncthing"; };

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

  # Networking
  networking = {
    hostName = "michael-desktop";
    domain = "michdavidadams.com";
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    wireless = {
        enable = true;
        scanOnLowSignal = false;
        environmentFile = "/home/michael/.keys/wireless.env";
        networks.MiSky.psk = "@PASS_MISKY@";
    };
    nat.enableIPv6 = true;
    useDHCP = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 1883 8080 ];
      };
  };

    system.stateVersion = "23.11";
}

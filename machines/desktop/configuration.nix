{ config, pkgs, lib, ... }:
let
  lights-off = ''
  exec mosquitto_pub -t 'zigbee2mqtt/living_room/set' -m '{ "state": "OFF" }'
  '';

in
{
  imports = [ ./hardware-configuration.nix ];
  hardware.facetimehd.enable = true;
  hardware.enableAllFirmware = true;

    users.users.michael.extraGroups = [ "mosquitto" ]

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };
    services.dbus.enable = true;
    programs.light.enable = true;
    programs.dconf.enable = true;
    hardware.opengl.enable = true;

      environment.systemPackages = with pkgs; [
     mosquitto sunwait
  ];

  # Smart home
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
    systemd.services = {
      lights-on = {
        description = "Turn on lights after boot";
        after = [ "sway-session.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.mosquitto pkgs.bash ];
        script = builtins.readFile ./lights-on.sh;
        serviceConfig.Type = "oneshot";
      };
      lights-off = {
        description = "Turn off lights before shutdown";
        after = [ "zigbee2mqtt.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.mosquitto pkgs.bash ];
        script = builtins.readFile ./lights-off.sh;
        serviceConfig.Type = "oneshot";
      };
      sunset = {
        description = "Change lights to evening scene if sunset";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.mosquitto pkgs.bash pkgs.sunwait ];
        script = builtins.readFile ./sunset.sh;
        serviceConfig.Type = "oneshot";
      };
    };
    systemd.timers = {
      sunset = {
        description = "Periodically run sunset service";
        wantedBy = [ "multi-user.target" ];
        timerConfig = {
          OnUnitActiveSec = "1800";
          Unit = "sunset.service";
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
  networking.hostName = "michael-desktop";

    system.stateVersion = "23.11";
}

{ config, lib, pkgs, ... }:
{
    services.gammastep = {
      enable = true;
      latitude = "34.2";
      longitude = "-85.1";
      provider = "manual";
      temperature.day = 5000;
      temperature.night = 3000;
    };
}

{ config, lib, pkgs, ... }:
{
  security = {
    rtkit.enable = true; # used by PulseAudio to aquire realtime priority idk what that means tbh
    pam.loginLimits = [ { domain = "@users"; item = "rtprio"; type = "-"; value = 1; } ]; # idk bout this one either i should figure this out
    polkit.enable = true; # for remembering passwords or somethin
    pam.services = {
      swaylock = {}; # so swaylock doesnt lock me out
      login.gnupg = { # so gnupg stays authenticated!!!!
        enable = true;
        storeOnly = true;
      };
    };
  };
}

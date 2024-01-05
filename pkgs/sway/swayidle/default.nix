{ config, lib, pkgs, ... }:
{
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
}

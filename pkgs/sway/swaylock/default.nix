{ config, lib, pkgs, ... }:
{
  stylix.targets.swaylock.enable = true;
    programs.swaylock = {
      enable = true;
      settings = {
        indicator-idle-visible = false;
        show-failed-attempts = false;
      };
    };
}

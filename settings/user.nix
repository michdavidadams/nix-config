{ config, lib, pkgs, ... }:
{
  users.users.michael = {
    isNormalUser = true;
    home = "/home/michael";
    name = "michael";
    description = "Michael Adams";
    extraGroups = [ "wheel" "audio" "video" ];
  };
}

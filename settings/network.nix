{ config, lib, pkgs, inputs, ... }:
{
  networking = {
    domain = "michdavidadams.com";
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    wireless = {
      enable = true;
      environmentFile = "/home/michael/.keys/wireless.env";
      networks = {
        MiSky.psk = "@PASS_MISKY@";
        Adams.psk = "@PASS_ADAMS@";
      };
    };

    firewall = {
      enable = true;
    };
  };

  inputs.hosts.nixosModule.networking.stevenBlackHosts = {
    enable = true;
    blockFakenews = true;
    blockGambling = true;
  }
  
}

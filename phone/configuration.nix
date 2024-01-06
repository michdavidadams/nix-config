{ config, lib, pkgs, nixvim, stylix, ... }:
{
environment.packages = with pkgs; [
    curl mpdscribble
    mosquitto
    (nerdfonts.override { fonts = [ "Lilex" ]; })
  ];
  environment.etcBackupExtension = ".bak";
  environment.motd = "󰈺 glub glub 󰈺";
  terminal.font = "${pkgs.nerdfonts.override {fonts = ["Lilex"];}}/share/fonts/truetype/NerdFonts/LilexNerdFontPropo-Regular.ttf";
  system.stateVersion = "23.05";
  user.shell = "${pkgs.zsh}/bin/zsh";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    '';
    time.timeZone = "America/New_York";

    home-manager = {
      config = {
        imports = [ ../home.nix nixvim.homeManagerModules.nixvim ../nixvim stylix.homeManagerModules.stylix ../stylix ];
        stylix = {
          autoEnable = false;
          targets.nixvim.enable = true;
          targets.fzf.enable = true;
        };
        programs.zsh.initExtra = ''
        mpdscribble
        '';
        home.stateVersion = "23.05";
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
}

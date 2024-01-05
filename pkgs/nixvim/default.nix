{ pkgs, config, lib, ... }: {

  stylix.targets.nixvim = {
    enable = true;
    transparent_bg.main = true;
    transparent_bg.sign_column = true;
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    clipboard.providers.wl-copy.enable = true;

    options = {
      number = true;
      shiftwidth = 2;

    };

    plugins = {
      nix.enable = true;
      treesitter.enable = true;
      telescope.enable = true;
      gitsigns.enable = true;
    };
  };
}

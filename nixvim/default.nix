{ pkgs, config, nixvim, ... }: {
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

{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [ ledger-autosync ];
  programs.ledger = {
    enable = true;
    settings = {
      date-format = "%Y-%m-%d";
      file = [
        "~/Documents/finances/journal.ledger"
        "~/Documents/finances/income.ledger"
      ];
      sort = "date";
    };
  };
}

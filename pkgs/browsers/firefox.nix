{ lib, config, pkgs, firefox-addons, ... }:
{
    programs.firefox = {
        enable = true;
        profiles.default = {
          bookmarks = [
              {
                name = "Syncthing";
                url = "http://localhost:8384/";
              }
              {
                name = "Zigbee2MQTT";
                url = "http://localhost:8080/";
              }
            ];
          extensions = with firefox-addons.packages.x86_64-linux; [
            darkreader ff2mpv ublock-origin-lite
          ];
          id = 0;
          isDefault = true;
          search = {
            default = "SearXNG";
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "SearXNG" = {
                urls = [{ template = "https://baresearch.org/search?q={searchTerms}"; }];
                icon = "https://upload.wikimedia.org/wikipedia/commons/b/b7/SearXNG-wordmark.svg";
              };
            };
            force = true;
          };
          settings = {
            "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "identity.fxaccounts.enabled" = false;
          };
        };

        policies = {
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableProfileImport = true;
            DisableSetDesktopBackground = true;
            DisableTelemetry = true;
            DNSOverHTTPS = {
                Enabled = true;
                ProviderURL = "https://dns.quad9.net/dns-query";
            };
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            PassManagerEnabled = false;

        };
    };


}

{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ sg3_utils ];
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    mpdIntegration.enableUpdate = true;
    settings = {
      directory = "${config.xdg.userDirs.music}";
      plugins = [ "bareasc" "chroma" "edit" "embedart" "fetchart" "fromfilename" "ftintitle" "lastimport" "lyrics" "permissions" "replaygain" "rewrite" "scrub" "smartplaylist" "zero" ];
      asciify_paths = true;
      original_date = true;
      ui.color = true;
      import = {
        move = true;
        write = true;
        resume = false;
        from_scratch = true;
        quiet = false;
        timid = true;
        autotag = true;
        bell = true;
      };
      match = {
        preferred = {
          countries = [ "XW|US" ];
          media = [ "Digital Media|File" "CD" ];
        };
        ignored_media = [ "Vinyl" "VHS" ];
        ignore_video_tracks = false;
      };
      paths = {
          default = "$albumartist/$album%aunique{}/$track $title";
          comp = "Various Artists/$album%aunique{}/$track $title";
          "albumtype:soundtrack" = "Various Artists/$album/$track $title";
          "albumtype:video game music" = "Various Artists/$album/$track $title";
          "albumtype:ost" = "Various Artists/$album/$track $title";
        };

        # Plugins
        chroma.auto = true;
        edit = {
          itemfields = "track title artist albumartist album genre";
          albumfields = "albumartist artist album genre";
        };
        embedart = {
          auto = true;
          ifempty = false;
          remove_art_file = true;
        };
        fetchart = {
          auto = true;
          cautious = false;
        };
        ftintitle = {
          auto = true;
          drop = true;
        };
        lastfm.user = "michdavidadams";
        lyrics = {
          auto = true;
          force = true;
        };
        musicbrainz.genres = true;
         replaygain = {
          backend = "ffmpeg";
          auto = true;
          overwrite = true;
        };
        rewrite = {
          "artist .*the beach boys.*" = "The Beach Boys";
          "artist .*glee cast.*" = "Glee Cast";
          "artist .*kerli feat.*" = "Kerli";
          "artist .*feat. kerli.*" = "Kerli";
          "artist .*ashley o.*" = "Miley Cyrus";
        };
        scrub.auto = true;
        smartplaylist = {
          auto = true;
          forward_slash = false;
          relative_to = "${config.xdg.userDirs.music}";
          playlist_dir = "${config.xdg.userDirs.music}";
          playlists = [ { name = "Most Played.m3u"; query = "play_count:25.. play_count-"; } ];
        };
        zero = {
          auto = true;
          fields = "month day comments";
        };
    };
  };
}

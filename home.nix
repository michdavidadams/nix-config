{ pkgs, config, lib, ... }:
let
  fzf-mpd = pkgs.writeShellScriptBin "fzf-mpd" ''
  mpc clear && mpc ls | fzf | mpc add -- && mpc play
  '';

in
{
  xdg.enable = true;
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
        enableCompletion = true;
        autocd = true;
        shellAliases = {
          mountcd = "sudo sg_raw /dev/sr0 EA 00 00 00 00 00 01";
          h = "himalaya";
        };
        dirHashes = {
          docs = "$HOME/Documents";
          vids = "$HOME/Videos";
          dl = "$HOME/Downloads";
        };
        initExtra = ''
        source ${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh
        SPACESHIP_TIME_SHOW=false

        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
        '';
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
        defaultCommand = "fd --type f";
      };

      home.packages = with pkgs; [
        todo-txt-cli
        fd unzip fzf-mpd spaceship-prompt zsh-nix-shell
      ];
      xdg.configFile."todo.cfg".text = ''
      export TODO_DIR="${config.xdg.configHome}/todo.cfg"
      export TODO_FILE="$TODO_DIR/todo.txt"
      export DONE_FILE="$TODO_DIR/done.txt"
      export REPORT_FILE="$TODO_DIR/report.txt"
      '';

    programs.gpg = {
        enable = true;
    };
    services.gpg-agent = {
        enable = true;
        enableBashIntegration = true;
        enableSshSupport = true;
        defaultCacheTtl = 86400;
        extraConfig = ''
        allow-loopback-pinentry
        allow-preset-passphrase
        '';
        maxCacheTtl = 86400;
        pinentryFlavor = "tty";
        sshKeys = [ "6401F6D65DBB4C02FF43DCEC808421D58908EFCC" ];
    };
    programs.password-store = {
        enable = true;
        package = (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]));
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
      };

    programs.git = {
        enable = true;
        userEmail = "me@michdavidadams.com";
        userName = "Michael Adams";
      };
      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };

      # Calendars
      accounts.calendar = {
        basePath = ".calendars";
      accounts.personal = {
      khal = {
        enable = true;
        color = "light blue";
        type = "discover";
      };
      primary = true;
      primaryCollection = "Calendar";
      local = {
        encoding = "UTF-8";
        fileExt = ".ics";
        type = "filesystem";
      };
      remote = {
        passwordCommand = [ "${(pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))}/bin/pass" "caldav" ];
        type = "caldav";
        url = "https://dav.mailbox.org/caldav/";
        userName = "me@michdavidadams.com";
      };
      vdirsyncer = {
        enable = true;
        auth = "basic";
        collections = [ "from a" "from b" ];
        conflictResolution = "remote wins";
        metadata = [ "displayname" ];
        timeRange.start = "datetime.now() - timedelta(days=365)";
        timeRange.end = "datetime.now() + timedelta(days=365)";
      };
    };
  };
  programs.khal = {
    enable = true;
    locale = {
      default_timezone = "America/New_York";
      local_timezone = "America/New_York";
    };
    settings = {
      default = {
        default_calendar = "Calendar";
        timedelta = "30d";
      };
      view = {
        agenda_event_format = "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
      };
    };
  };
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  # Contacts
  accounts.contact = {
    basePath = ".contacts";
    accounts.personal = {
      khal.enable = false;
      khard.enable = false;
      local = {
        encoding = "UTF-8";
        type = "filesystem";
        fileExt = ".vcf";
      };
      remote = {
        passwordCommand = [ "${(pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))}/bin/pass" "carddav" ];
        type = "carddav";
        url = "https://dav.mailbox.org/carddav/";
        userName = "me@michdavidadams.com";
      };
      vdirsyncer = {
        enable = true;
        auth = "basic";
        collections = [ "from a" "from b" ];
        conflictResolution = "remote wins";
        metadata = [ "displayname" ];
      };
    };
  };
  programs.khard.enable = true;

  # Email
  accounts.email = {
    maildirBasePath = ".mail";
    accounts.personal = {
      address = "me@michdavidadams.com";
      himalaya.enable = true;
      imap = {
        host = "imap.mailbox.org";
        port = 993;
      };
      smtp = {
        host = "smtp.mailbox.org";
        port = 465;

      };
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "maildir";
        remove = "both";
      };
      userName = "me@michdavidadams.com";
      passwordCommand = "pass Mailbox.org";
      primary = true;
      realName = "Michael Adams";
    };
  };
  programs.himalaya.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;

  programs.yt-dlp = {
    enable = true;

  };
}

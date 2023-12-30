{ lib, config, pkgs, ... }:

{
     environment.systemPackages = with pkgs; [ pam_gnupg (pass.withExtensions (exts: [ exts.pass-otp ])) gnupg ];
    programs.gnupg = {
        agent = {
            enable = true;
            enableSSHSupport = true;
            pinentryFlavor = "tty";
            settings = {
                max-cache-ttl = 86400;
            };
        };
    };

  security.pam.services = {
      login.gnupg = {
          enable = true;
          storeOnly = true;
      };
  };

}

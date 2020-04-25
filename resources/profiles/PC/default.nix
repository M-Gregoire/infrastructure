{ pkgs, lib,... }:

{
  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    pcs = {
      browser = "firefox";
      mailer = "thunderbird";
      terminal = "kitty";
    };
    services.redshift.temperature = {
      day = 6500; # As if redshift is not running
      night = 4500;
    };
  };
}

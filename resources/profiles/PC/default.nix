{ pkgs, lib,... }:

{
  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    pcs = {
      browser = "firefox";
      mailer = "thunderbird";
      terminal = "kitty";
    };
  };
}

{ pkgs, lib,... }:

{
  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    browser = "firefox";
    mailer = "thunderbird";
    terminal = "kitty";
  };
}

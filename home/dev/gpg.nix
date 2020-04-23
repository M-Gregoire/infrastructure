{ pkgs, ... }:

{
  home.packages = with pkgs; [pinentry-gtk2];
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
  };
}

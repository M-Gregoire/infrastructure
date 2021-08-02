{ pkgs, config, ... }:

{

  home.file.".gnupg/gpg.conf".source = builtins.toPath "${config.resources.paths.publicDotfiles}/gnupg/gpg.conf";

  home.packages = with pkgs; [pinentry-gtk2];
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
    # For gpg forwarding
    enableExtraSocket = true;
  };
}

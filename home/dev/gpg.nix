{ pkgs, config, flake-root, ... }:

{

  home.file.".gnupg/gpg.conf".source =
    builtins.toPath "${flake-root}/gnupg/gpg.conf";

  home.packages = with pkgs; [ pinentry-gtk2 ];
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gtk2";
    # For gpg forwarding
    enableExtraSocket = true;
  };
}

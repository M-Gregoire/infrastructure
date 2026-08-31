{
  pkgs,
  config,
  flake-root,
  ...
}:

{

  home.file.".gnupg/gpg.conf".source = builtins.toPath "${flake-root}/dotfiles/gnupg/gpg.conf";

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    # For gpg forwarding
    enableExtraSocket = true;
  };
}

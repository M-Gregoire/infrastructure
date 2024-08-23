{ pkgs, config, flake-root, ... }:

{

  home.file.".gnupg/gpg.conf".source =
    builtins.toPath "${flake-root}/gnupg/gpg.conf";

  home.packages = with pkgs; [ pinentry-gtk2 ];
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    #pinentryFlavor = "gtk2";
    # TODO: - gregoire profile: The option definition `services.gpg-agent.pinentryFlavor' in `/nix/store/fd8bcb91lxy8f6401ab6w12zahb9wg4a-source/home/dev/gpg.nix' no longer has any effect; please remove it.
      # Use services.gpg-agent.pinentryPackage instead
    # For gpg forwarding
    enableExtraSocket = true;
  };
}

{ config, lib, pkgs, options, user, hostname, private-config, ... }:

{
  imports = [ ../../dev/wireguard-tools.nix ];

  # Configure Git safe directories for root user (needed for darwin-rebuild/nixos-rebuild with sudo)
  # Note: Uses home-manager config to get home directory, works for both Linux and macOS
  environment.etc."gitconfig".text = let
    infraPath = builtins.replaceStrings [ "/home/" ] [ "/Users/" ]
      (builtins.replaceStrings [ "/Users/" ] [ "/home/" ] "${
          config.home-manager.users.${user}.home.homeDirectory
        }/src/infrastructure");
  in ''
    [safe]
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure-private
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/dotfiles/doom.d
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/vendor/polybar-spotify
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/vendor/rofi
  '';

  # programs = {
  #   zsh = {
  #     # Fix Tramp (Emacs) with ZSH https://www.emacswiki.org/emacs/TrampMode#toc9
  #     interactiveShellInit = ''
  #       [[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return
  #     '';
  #   };
  # };

  # # Move garbage collection for 3:15 to 14:00
  # #nix.gc.dates = "14:00";
  # # TODO: The option definition `nix.gc.dates' in `/nix/store/fd8bcb91lxy8f6401ab6w12zahb9wg4a-source/nixos/profiles/PC' no longer has any effect; please remove it.
  # #     Use `nix.gc.interval` instead.

  # home-manager.users.${user} =
  #   { ... }:
  #   {
  #     imports = [
  #       ../../../home
  #       (../../../home/hosts + builtins.toPath "/${hostname}")
  #     ];
  #     # Pass to home-manager
  #     resources = config.resources;
  #   };

  fonts.packages = with pkgs; [
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.hack
    fira-code
    fira-code-symbols
  ];

}

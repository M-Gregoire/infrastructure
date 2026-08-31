{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [ ../../dev/wireguard-tools.nix ];

  # Configure Git safe directories for root user (needed for darwin-rebuild/nixos-rebuild with sudo)
  # Note: Uses home-manager config to get home directory, works for both Linux and macOS
  environment.etc."gitconfig".text = ''
    [safe]
      directory = ${config.home-manager.users.${user}.home.homeDirectory}/src/infrastructure
      directory = ${config.home-manager.users.${user}.home.homeDirectory}/src/infrastructure-private
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/dotfiles/doom.d
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/vendor/polybar-spotify
  '';

  # programs = {
  #   zsh = {
  #     # Fix Tramp (Emacs) with ZSH https://www.emacswiki.org/emacs/TrampMode#toc9
  #     interactiveShellInit = ''
  #       [[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return
  #     '';
  #   };
  # };

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

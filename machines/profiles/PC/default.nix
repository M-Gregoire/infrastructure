{
  config,
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [ ../../dev/wireguard-tools.nix ];

  # Lets client-side nix overrides (e.g. `--option substituters`,
  # `--no-cache` in nix-deploy) actually take effect instead of being
  # silently ignored by the daemon, which otherwise only honors them from
  # `root`. Tradeoff: a trusted user can substitute unsigned build outputs,
  # effectively gaining root via the nix daemon.
  nix.settings.trusted-users = [ user ];

  # Configure Git safe directories for root user (needed for darwin-rebuild/nixos-rebuild with sudo)
  # Note: Uses home-manager config to get home directory, works for both Linux and macOS
  environment.etc."gitconfig".text = ''
    [safe]
      directory = ${config.home-manager.users.${user}.home.homeDirectory}/src/infrastructure
      directory = ${config.home-manager.users.${user}.home.homeDirectory}/src/infrastructure-private
      directory = ${
        config.home-manager.users.${user}.home.homeDirectory
      }/src/infrastructure/dotfiles/doom.d
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

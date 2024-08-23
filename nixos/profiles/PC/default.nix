{ config, lib, pkgs, options, private-config, ... }:

{
  imports = [
    "${private-config}/resources/profiles/PC"
    ./resources.nix
    ../../dev/wireguard-tools.nix
    (if pkgs.stdenv.isLinux then ./linux.nix else ./darwin.nix)
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs = {
    zsh = {
      # Fix Tramp (Emacs) with ZSH https://www.emacswiki.org/emacs/TrampMode#toc9
      interactiveShellInit = ''
        [[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return
      '';
    };
  };

  # Move garbage collection for 3:15 to 14:00
  #nix.gc.dates = "14:00";
  # TODO: The option definition `nix.gc.dates' in `/nix/store/fd8bcb91lxy8f6401ab6w12zahb9wg4a-source/nixos/profiles/PC' no longer has any effect; please remove it.
  #     Use `nix.gc.interval` instead.

  home-manager.users.${config.resources.username} = { ... }: {
    imports = [
      ../../../home
      (../../../home/hosts + builtins.toPath "/${config.resources.hostname}")
    ];
    # Pass to home-manager
    resources = config.resources;
  };

  fonts.packages = with pkgs; [ nerdfonts ];

}

{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:
{

  imports = [ ./shortcuts.nix ];
  # # Sketchybar config is shipped with home-manager but run as a service with nix-darwin
  # services.sketchybar = {
  #   enable = true;
  #   extraPackages = [ pkgs.aerospace pkgs.coreutils pkgs.gnugrep ];
  # };

  # nixpkgs.hostPlatform = lib.mkForce "aarch64-darwin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    # Emacs requirements
    nixfmt-rfc-style
    fd
    coreutils
    aspell
    direnv
    dockfmt
    editorconfig-checker
    # Others
    ansible

  ];

  homebrew.enable = true;
  # homebrew.taps = [ "railwaycat/emacsmacport" ];
  homebrew.brews = [

    "git"
    "ripgrep"
    "aws-vault"
    "pyenv"
    "borders"
    "node"
    "tfenv"
    "awscli"
    "k9s"
  ];

  homebrew.casks = [

    {
      name = "emacs-mac";
      #args = { appdir = "~/my-apps/Applications"; };
    }

    "datadog/tap/dd-gitsign"
    "datadog/tap/dd-auth"
    "google-cloud-sdk"
    "nikitabobko/tap/aerospace"
    "hammerspoon"
    "raycast"
    "kitty"
    "font-hack-nerd-font"
    "notunes"
    "bluesnooze"
    "karabiner-elements"
    "1password-cli"
    "aws-vault"
    "cursor"
  ];
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  system.primaryUser = "${user}";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}

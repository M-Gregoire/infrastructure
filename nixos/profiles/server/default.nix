{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ../../../vendor/infrastructure-private/resources/profiles/server
  ];

  environment.systemPackages = with pkgs; [
    # Terminfo for Kitty
    kitty.terminfo
    # make
    gnumake
    # git
    git
    # Utilities
    wget
    unzip
    # Certificate
    openssl
    # gpg
    gnupg
    # lsusb
    usbutils
  ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;

  home-manager.users.${config.resources.username} = { ... }: {
    imports = [ (../../../home/profiles/server) ];
    # Pass to home-manager
    nixpkgs.overlays = config.nixpkgs.overlays;
    nixpkgs.config = import ../../../nixpkgs/config.nix;
    resources = config.resources;
    home.stateVersion = "22.11";
  };

}

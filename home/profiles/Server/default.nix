{ config, ... }:

{
  imports = [
    ../../../modules
    ../../dev/gpg.nix
    ../../dev/ssh.nix
  ];

  nixpkgs.config = import ../../../nixpkgs/config.nix;
  nixpkgs.overlays = import ../../../nixpkgs/overlays.nix;
  xdg.configFile."nixpkgs".source = ../../../nixpkgs;

  programs.home-manager.enable = true;

  programs.ssh = {
    # https://wiki.gnupg.org/AgentForwarding
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
}

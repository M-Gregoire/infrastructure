{ config, ... }:

{
  imports = [ ../../../modules ../../dev/gpg.nix ../../dev/ssh.nix ];

  xdg.configFile."nixpkgs".source = ../../../nixpkgs;

  programs.home-manager.enable = true;

  programs.ssh = {
    # https://wiki.gnupg.org/AgentForwarding
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
}

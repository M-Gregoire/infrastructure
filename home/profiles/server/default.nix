{ config, ... }:

{
  imports = [ ../../../modules ../../dev/linux/gpg-agent.nix ../../dev/ssh.nix ];


  programs.home-manager.enable = true;

  programs.ssh = {
    # https://wiki.gnupg.org/AgentForwarding
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
}

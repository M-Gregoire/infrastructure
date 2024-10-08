{ config, private-config, ... }:

{
  imports = [ "${private-config}/resources/home/ssh.nix" ];

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    # Allow gpg forwarding
    # https://wiki.gnupg.org/AgentForwarding
    #matchBlocks.gpgtunnel = {
    #  host = "gpgtunnel";
    #  hostname = "*.${config.resources.domain}";
    #  remoteForwards = [
    #    {
    #      host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
    #      bind.address = "/run/user/1000/gnupg/S.gpg-agent";
    #    }
    #  ];
    #};
  };
}

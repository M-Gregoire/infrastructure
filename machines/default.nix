{ config, pkgs, lib, user, hostname, cluster, clusterRole, profile, network
, inputs, ... }:

{
  imports = lib.flatten [ ../modules ./dev/term.nix ];

  config = {

    environment.systemPackages = with pkgs; [
      # File type
      file
      # DNS utils (dig)
      dnsutils
      # htop
      htop
      # tmux
      tmux
      # tree
      tree
      # dhclient
      # dhcp
      # lsof
      lsof
    ];

    users.groups.${user} = {
      name = user;
      members = [ user ];
      gid = 1000;
    };

    users.users.${user} = {
      home =
        (if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}");
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
    };

    time.timeZone = "Europe/Paris";

    security.pki.certificates = config.resources.pki.acrs;

    nix.gc = { automatic = true; };
  };

}

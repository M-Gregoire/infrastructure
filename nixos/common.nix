{ config, pkgs, lib, hostname, cluster ? "", clusterRole ? "", profile, network
, inputs, ... }:

# Note: It appears impossible to create the import paths
# based on the define hostname through options (https://www.reddit.com/r/NixOS/comments/q2t69g/comment/hfrd1ig)
#

{
  imports = lib.flatten [
    ../modules
    ../resources/common.nix
    (./. + "/profiles/${profile}")
    (./. + "/networks/${network}")

    (if cluster == "" then
      ../. + "/resources/hosts/${hostname}"
    else [
      (import (../. + "/resources/hosts/${cluster}") {
        inherit config pkgs lib clusterRole;
      })
      (import "${inputs.private-config}/resources/hosts/${cluster}" {
        inherit config pkgs lib clusterRole;
      })
      (import (./. + "/hosts/${cluster}") {
        inherit config pkgs lib clusterRole;
      })
      (../. + "/resources/hosts/${cluster}/${hostname}")
    ])

    (if pkgs.stdenv.isLinux then
      (import ./system/linux)
    else
      (import ./system/darwin))
  ];

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

    users.groups.${config.resources.username} = {
      name = "${config.resources.username}";
      members = [ "${config.resources.username}" ];
      gid = 1000;
    };

    users.users.${config.resources.username} = {
      home = (if pkgs.stdenv.isLinux then
        "/home/${config.resources.username}"
      else
        "/Users/${config.resources.username}");
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
    };

    time.timeZone = "Europe/Paris";

    security.pki.certificates = config.resources.pki.acrs;

    nix.settings.auto-optimise-store = true;
    nix.gc = { automatic = true; };
  };

}

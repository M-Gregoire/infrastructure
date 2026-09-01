{ config, lib, pkgs, private-config, ... }:

{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."attic/token" = {
    sopsFile = builtins.toPath "${private-config}/secrets/attic.yaml";
    path = "/etc/attic/token";
    mode = "0400";
  };
}

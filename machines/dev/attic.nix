{ config, lib, pkgs, flake-root, ... }:

{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."attic/token" = {
    sopsFile = builtins.toPath "${flake-root}/secrets/attic.yaml";
    path = "/etc/attic/token";
    mode = "0400";
  };
}

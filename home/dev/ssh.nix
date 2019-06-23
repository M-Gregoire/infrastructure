{ config, ... }:

{
  imports = [
    ../../vendor/infrastructure-private/resources/home/ssh.nix
  ];

  programs.ssh = {
    enable = true;
  };
}


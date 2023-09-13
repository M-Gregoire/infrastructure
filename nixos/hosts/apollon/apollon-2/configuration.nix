{ config, pkgs, lib, ... }: {
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "apollon-2";
      cluster = "apollon";
      clusterRole = "agent";
      profile = "server";
      network = "cloud";
    })
    ./hardware-configuration.nix
  ];

  system.stateVersion = "20.03";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  security.sudo.wheelNeedsPassword = false;

  services.k3s = {
    enable = true;
    role = "agent";
  };

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];
}

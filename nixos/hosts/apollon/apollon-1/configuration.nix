{ config, pkgs, lib, ... }: {
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "apollon-1";
      cluster = "apollon";
      clusterRole = "server";
      profile = "server";
      network = "cloud";
    })
    ./hardware-configuration.nix
  ];

  system.stateVersion = "20.03";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  security.sudo.wheelNeedsPassword = false;

  services.k3s.enable = true;
  services.k3s.role = "server";

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];
}

{ config, pkgs, lib, inputs, flake-root, ... }: {
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "dcf8a7751aa94acab2d61bb6edb85ece";

  system.stateVersion = "20.03";

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    k3s
    containerd
    kubectl
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  # mkdir -p /nfs/Cameras && chattr +i /nfs/Cameras
  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/c78289ef-b0bf-48c0-a17c-02d6f2cbed6c";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Cameras    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = "";
}

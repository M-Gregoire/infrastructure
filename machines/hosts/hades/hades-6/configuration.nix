{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "dcf8a7751aa94acab1e61bb6edb85ece";

  system.stateVersion = "20.03";

  services.datadog-agent = {
    enable = true;
    site = "datadoghq.eu";
    hostname = "hades-6";
    apiKeyFile = "/run/keys/datadog_api_key";

    tags = [ "env:prod" "role:host" ];
    extraConfig = {
      logs_enabled = true;
      logs_config.use_http = true;
      api_key = "<secret-here-with-sops>";
    };
    checks.journald = {
      logs = [{
        type = "journald";
        path = "/var/log/journal";
        # include_units = [ "sshd.service" "k3s.service" ];
        service = "system"; # tag 'service:system' on these entries
        source = "journald";
      }];
    };

  };

  systemd.services.datadog-agent.serviceConfig.SupplementaryGroups =
    [ "systemd-journal" ];
  # users.users.datadog.extraGroups = [ "systemd-journal" ];

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    k3s
    containerd
    kubectl
    usb-modeswitch
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

  # Increase GPU mem for Frigate
  # https://docs.frigate.video/configuration/hardware_acceleration/#raspberry-pi-34
  # boot.loader.raspberryPi = {
  #   enable = true;
  #   firmwareConfig = ''
  #     gpu_mem=128
  #   '';
  # };
}

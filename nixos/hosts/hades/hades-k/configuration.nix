{ config, pkgs, lib, linuxKernel, ... }:

let

  customPkgs = (import ~/src/nixpkgs {
    config.allowUnfree = true;
    hostplatform = "armv7l-linux";
    buildPlatform = "x86_64-linux";
    system = "aarch64-linux";
    # config.platform = lib.systems.platforms.raspberrypi4;
    # crossSystem = "aarch64-linux";
  });
  # .pkgsCross.aarch64-multiplatform;
in {
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "hades-k";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
    <nixos-hardware/raspberry-pi/4>
    <home-manager/nixos>
  ];

  system.stateVersion = "20.03";

  fileSystems."/nfs/Safe" = {
    device = "banana.martinache.net:/Safe";
    fsType = "nfs";
    options =
      [ "x-systemd.automount" "noauto" "nolock" "x-systemd.idle-timeout=600" ];
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;

  services.xserver.desktopManager.kodi.package = customPkgs.kodi.withPackages
    (kodiPkgs:
      with kodiPkgs; [
        arteplussept
        youtube
        pvr-hts
        # catchuptvandmore
      ]);
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";

  # This may be needed to force Lightdm into 'autologin' mode.
  # Setting an integer for the amount of time lightdm will wait
  # between attempts to try to autologin again.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.autoLogin.timeout = 3;

  users.extraUsers.kodi.isNormalUser = true;
  users.users.kodi = {
    extraGroups = [
      # Give access to CEC adapter
      "dialout"
    ];
  };

  home-manager.users.kodi = { ... }: {
    home.stateVersion = "23.05";
    programs.home-manager.enable = true;

    # programs.kodi = {
    #   enable = true;

    # sources = {
    #   video = {
    #     default = "";
    #     source = [
    #       {
    #         name = "movies";
    #         path = "/nfs/Safe/services/movies/";
    #         allowsharing = "true";
    #       }
    #       {
    #         name = "tvseries";
    #         path = "/nfs/Safe/services/tvseries/";
    #         allowsharing = "true";
    #       }
    #     ];
    #   };
    # };

    # addonSettings = { };
    # };

    # home.file.".kodi/userdata/addon_data/pvr.hts/instance-settings-1.xml" =
    #   "${config.resources.paths.secrets}/kodi/pvr.hts.config.xml";
  };

  boot.loader.grub.enable = false;

  # boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  # Fix k3s
  boot.kernelParams = [
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
    # https://www.suse.com/support/kb/doc/?id=7014266
    "nfs.nfs4_disable_idmapping=1"

  ];
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.k3s
    pkgs.containerd
    pkgs.kubectl
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];
}

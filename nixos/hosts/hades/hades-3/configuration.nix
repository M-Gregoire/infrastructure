 { config, pkgs, lib, linuxKernel, ... }:
 let

   ko = lib.overrideScope pkgs.kodiPackages
     (self: super: { invidious-test = ./callPackage ./invidious.nix { }; });

   # kodiOverlay = (final: prev: {
   #   kodiPackages = prev.kodiPackages.overrideScope (kfinal: kprev: {
   #     invidious-test = kprev.callPackage ./invidious.nix { };
   #   });
   # });

   # kodiPkgs = import <nixpkgs> { overlays = [ kodiOverlay ]; };

 in {

   imports = [

     (import ../../../common.nix {
       inherit config pkgs lib;
       hostname = "hades-3";
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

   services.xserver.enable = true;
   services.xserver.desktopManager.kodi.enable = true;
   # services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (pkgs:
   #   with pkgs; [
   #     youtube
   #     pvr-hts
   #     invidious-test
   #     arteplussept
   #     #steamlauncher
   #     # catchuptvandmore
   #   ]);
   services.xserver.desktopManager.kodi.package =
     pkgs.kodi.withPackages (pkgs: [ ko.pkgs.invidious-test ]);
   services.xserver.displayManager.autoLogin.enable = true;
   services.xserver.displayManager.autoLogin.user = "kodi";

   users.users.kodi = {

     extraGroups = [ "${config.resources.username}" ];
   };

   home-manager.users.kodi = { ... }: {
     home.stateVersion = "23.05";
     programs.home-manager.enable = true;

     programs.kodi = {
       enable = true;

       sources = {
         video = {
           default = "";
           source = [
             {
               name = "movies";
               path = "/nfs/Safe/services/movies/";
               allowsharing = "true";
             }
             {
               name = "tvseries";
               path = "/nfs/Safe/services/tvseries/";
               allowsharing = "true";
             }
           ];
         };
       };
     };

   };

   # services.cage.user = "kodi";
   # services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
   # services.cage.enable = true;

   # This may be needed to force Lightdm into 'autologin' mode.
   # Setting an integer for the amount of time lightdm will wait
   # between attempts to try to autologin again.
   services.xserver.displayManager.lightdm.enable = true;
   services.xserver.displayManager.lightdm.autoLogin.timeout = 3;

   # Define a user account
   users.extraUsers.kodi.isNormalUser = true;

   boot.loader.grub.enable = false;
   # boot.loader.grub.device = "/dev/mmcblk2"; # or "nodev" for efi only

   # fileSystems."/nfs/Cameras" = {
   #   device = "/dev/disk/by-uuid/7bd9f6e9-c8e8-4b6d-b0d7-851b1fc4833e";
   #   fsType = "ext4";
   #   # options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
   #   options =
   #     [ "noauto" "nofail" "x-systemd.automount" "x-systemd.device-timeout=30" ];
   # };

   #boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;
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
   # boot.kernelModules = [ "cxd2880" "cxd2880-spi" ];

   environment.systemPackages = with pkgs; [
     # libraspberrypi
     # raspberrypi-eeprom
     pkgs.k3s
     pkgs.containerd
     pkgs.kubectl
   ];
   # hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
   # hardware.deviceTree = {
   #   enable = true;
   #   filter = "*-rpi-4*.dtb";
   #   overlays = [
   #     #   {
   #     #   name = "rpi-tv";
   #     #   dtboFile = ./rpi-tv.dtbo;
   #     # }
   #     {
   #       name = "rpi-tv";
   #       dtsText = ''
   #         /dts-v1/;

   #         / {
   #          compatible = "raspberrypi";

   #          fragment@0 {
   #            target = <0xffffffff>;

   #            __overlay__ {
   #              status = "disabled";
   #            };
   #          };

   #          fragment@1 {
   #            target = <0xffffffff>;

   #            __overlay__ {
   #              #address-cells = <0x01>;
   #              #size-cells = <0x00>;
   #              status = "okay";

   #              cxd2880@0 {
   #                compatible = "sony,cxd2880";
   #                reg = <0x00>;
   #                spi-max-frequency = <0x2faf080>;
   #                status = "okay";
   #              };
   #            };
   #          };

   #          __fixups__ {
   #            spidev0 = "/fragment@0:target:0";
   #            spi0 = "/fragment@1:target:0";
   #          };
   #         };
   #       '';
   #     }
   #   ];
   # };

   services.k3s = {
     enable = true;
     role = "agent";
   };

   networking.firewall.allowedTCPPorts = [ 6443 ];

   # services.udev.extraRules = ''
   #   # Make alias for Google Coral
   #   SUBSYSTEM=="tty", ATTRS{idVendor}=="1a6e", ATTRS{idProduct}=="089a", SYMLINK+="ttyUSB-Google-Coral"
   # '';

 }

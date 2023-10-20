 { config, pkgs, lib, linuxKernel, ... }: {
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

   boot.loader.grub.enable = false;

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
 }

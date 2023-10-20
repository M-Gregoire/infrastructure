 { config, pkgs, lib, linuxKernel, ... }: {
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
     pkgs.kodi.withPackages (pkgs: [ ]);
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

   # This may be needed to force Lightdm into 'autologin' mode.
   # Setting an integer for the amount of time lightdm will wait
   # between attempts to try to autologin again.
   services.xserver.displayManager.lightdm.enable = true;
   services.xserver.displayManager.lightdm.autoLogin.timeout = 3;

   # Define a user account
   users.extraUsers.kodi.isNormalUser = true;

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

   services.k3s = {
     enable = true;
     role = "agent";
   };

   networking.firewall.allowedTCPPorts = [ 6443 ];

 }

{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/vali
      ../../../vendor/infrastructure-private/resources/hosts/vali
      ../../../vendor/infrastructure-private/resources/networks/home/nfs-safe.nix
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/boot/grub-uefi.nix
      ../../dev/suspend.nix
      ../../networks/home
      ../../profiles/PC
      ./../../dev/luks.nix
      ./hardware-configuration.nix
    ];

  services.xserver.libinput = {
    # Enable tapping
    enable = true;
    tapping = true;
    accelProfile = "adaptive";
    accelSpeed = "2";
  };

  networking.wireless.enable = true;

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.vali.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.vali.ssh.port ];

  boot.loader.grub.efiSupport = true;

  system.stateVersion = "20.03";

  #console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

}

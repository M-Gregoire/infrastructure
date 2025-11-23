{ config, lib, pkgs, ... }:

{
  imports = [ ../../dev/datadog.nix ../../dev/linux/systemd-networkd.nix ];

  environment.systemPackages = with pkgs;
    [ ceph ceph-client util-linux gptfdisk smartmontools ]
    ++ lib.optionals (config.networking.hostName != "hades-7")
    [ libraspberrypi ];

  boot.kernelModules =
    [ "nbd" "rbd" "ceph" "usb_storage" "uas" "usbhid" "xhci_pci" ];
  # boot.kernelParams = [
  #   # 174c:55aa ASMedia Technology Inc. ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge
  #   # 14b0:0206 StarTech.com Ltd. SDSSDA480G
  #   # 7825:a2a4 Other World Computing External SATA Hard Drive Adapter cable PA023U3
  #   # 004: ID 0bda:9210 Realtek Semiconductor Corp. RTL9210 M.2 NVME Adapter
  #   # "usb-storage.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
  #   # "usbcore.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
  #   "usb-storage.quirks=0bda:9210:u"
  # ];
  # boot.kernelParams = [ "usb_storage.use_uas=0" "usbcore.autosuspend=-1" ];
  # fileSystems."/var/log" = {
  #   device = "tmpfs";
  #   fsType = "tmpfs";
  #   options = [ "size=300M" "mode=0755" ];
  # };

  # Write log files to tmpfs
  # systemd.tmpfiles.rules = [
  #   "d /var/log/journal 2755 root systemd-journal -"
  #   "d /var/log/journal/%m 2755 root systemd-journal -"
  # ];

  # https://serverfault.com/a/949159
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };

  # boot.blacklistedKernelModules = [ "uas" ];
  # https://github.com/raspberrypi/linux/issues/5060#issuecomment-1306322303
  # https://www.reddit.com/r/NixOS/comments/znh1fm/blacklisting_in_uas_module/
  # boot.extraModprobeConfig = ''
  #   options usb-storage quirks=174c:55aa:u
  # '';
}

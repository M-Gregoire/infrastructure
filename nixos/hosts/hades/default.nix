{ config, lib, pkgs, ... }:

{
  imports = [ ../../dev/linux/systemd-networkd.nix ];

  boot.kernelModules = [ "nbd" "rbd" "ceph" "usb_storage" ];

  boot.kernelParams = [
    # 174c:55aa ASMedia Technology Inc. ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge
    # 14b0:0206 StarTech.com Ltd. SDSSDA480G
    # 7825:a2a4 Other World Computing External SATA Hard Drive Adapter cable PA023U3
    "usb-storage.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
    "usbcore.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
  ];

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

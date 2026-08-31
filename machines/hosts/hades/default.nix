{
  config,
  configName,
  lib,
  pkgs,
  ...
}:

let
  rpiHadesNodes = [
    "hades-1"
    "hades-2"
    "hades-3"
    "hades-4"
    "hades-5"
    "hades-6"
  ];
  isRpiHadesNode = lib.elem configName rpiHadesNodes;
in
{
  imports = [
    ../../dev/datadog.nix
    ../../dev/attic.nix
    ../../dev/linux/systemd-networkd.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      ceph
      ceph-client
      util-linux
      gptfdisk
      smartmontools
    ]
    ++ lib.optionals (config.networking.hostName != "hades-7") [ libraspberrypi ];

  # Auto-boot default generation after 3s (extlinux/U-Boot)
  boot.loader.timeout = 3;

  # nixos-hardware provides the RPi4 kernel via mkDefault.
  # Not cached by Hydra yet — first build is slow, but cached locally after.

  boot.kernelPackages = lib.mkIf isRpiHadesNode (lib.mkForce pkgs.linuxPackages_rpi4);

  # Backport libceph AES256K support from mainline 7.0 to the RPi 6.18 kernel.
  # Required for CephX key migration to aes256k (see hades-cluster/ceph-aes.md).
  # Commit 1/5 (ac431d597a9b "define and enforce CEPH_MAX_KEY_LEN") is already
  # present in the pinned Raspberry Pi 6.18 source.
  boot.kernelPatches = lib.mkIf isRpiHadesNode [
    {
      name = "libceph-generalize-encrypt-offset-buflen";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/0ee8bccf7396d50726c9c8dd3135fb64a9fe8426.patch";
        hash = "sha256-FlvmZTkt5b1HpysV1vOSXHm+roG/ZI9tCitW3MazhHk=";
      };
    }
    {
      name = "libceph-introduce-crypto-key-prepare";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/6cec0b61aacce4da5125b21c718189f0dc11eb51.patch";
        hash = "sha256-uIqJG4MAwaEzemNtcJZDVVc8B5XvOOIZrnifWVAlrR4=";
      };
    }
    {
      name = "libceph-aes256krb5-support";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/b7cc142dbafeaf6c053284ca9121b9f70b6d6d06.patch";
        hash = "sha256-yiJy+o3aN3JaLeNntLggKArCOP7Yzos7PJlX3ziFhZY=";
      };
    }
    {
      name = "libceph-challenge-blob-hashing-msgr1-signing";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/8356b4b1103b8c970648c94bab724aa30e42d869.patch";
        hash = "sha256-BeFZncgJ/NjWb4xiwMFREp/3fwLXpT/SVbcqRQGKfmk=";
      };
    }
  ];

  boot.kernelModules = [
    "nbd"
    "rbd"
    "ceph"
    "usb_storage"
    "uas"
    "usbhid"
    "xhci_pci"
  ];
  # boot.kernelParams = [
  #   # 174c:55aa ASMedia Technology Inc. ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge
  #   # 14b0:0206 StarTech.com Ltd. SDSSDA480G
  #   # 7825:a2a4 Other World Computing External SATA Hard Drive Adapter cable PA023U3
  #   # 004: ID 0bda:9210 Realtek Semiconductor Corp. RTL9210 M.2 NVME Adapter
  #   # "usb-storage.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
  #   # "usbcore.quirks=174c:55aa:u,14b0:0206:u,7825:a2a4:u"
  #   "usb-storage.quirks=0bda:9210:u"
  # ];
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  # boot.kernelParams = [ "usb_storage.use_uas=0" ];
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

  # Cap journal size — default (10% of fs) allows multi-GB accumulation that
  # causes I/O errors when rotation fails after an unclean shutdown.
  services.journald.extraConfig = ''
    SystemMaxUse=512M
  '';

  # Prevent LVM from scanning RBD/NBD devices — avoids circular deadlock
  # where ceph-volume activate -> lvs -> scans RBD -> blocks waiting for OSD
  environment.etc."lvm/lvm.conf".text = ''
    devices {
      filter = ["r|/dev/rbd.*|", "r|/dev/nbd.*|", "a|.*|"]
    }
  '';

  # https://serverfault.com/a/949159
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    # Auto-reboot on hung tasks (e.g. Ceph RBD I/O stalls)
    # Detects tasks blocked for 120s, panics, then reboots after 10s (kernel.panic=10)
    "kernel.hung_task_panic" = 1;
  };

  # Hardware watchdog — reboots if the system becomes completely unresponsive
  systemd.settings.Manager.RuntimeWatchdogSec = "30s";
  systemd.settings.Manager.RebootWatchdogSec = "10min";

  # boot.blacklistedKernelModules = [ "uas" ];
  # https://github.com/raspberrypi/linux/issues/5060#issuecomment-1306322303
  # https://www.reddit.com/r/NixOS/comments/znh1fm/blacklisting_in_uas_module/
  # boot.extraModprobeConfig = ''
  #   options usb-storage quirks=174c:55aa:u
  # '';
}

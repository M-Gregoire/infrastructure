{ config, pkgs, lib, inputs, flake-root, ... }: {
  imports = [

    ./hardware-configuration.nix
  ];

  # Use RPi vendor kernel 6.18 from nixos-raspberrypi for aes256k CephX backport path.
  # lib.mkForce overrides the nixos-hardware vendor kernel 6.12 (mkDefault).
  # Testing on hades-6 first before rolling out to all nodes.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;

  # Backport libceph AES256K support from mainline 7.0 to RPi 6.18 kernel.
  # Required for CephX key migration to aes256k (see hades-cluster/ceph-aes.md).
  # 4 commits by Ilya Dryomov, all within net/ceph/ + include/linux/ceph/.
  # Commit 1/5 (ac431d597a9b "define and enforce CEPH_MAX_KEY_LEN") already
  # in 6.18 stable via AUTOSEL.
  boot.kernelPatches = [
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

  environment.etc."machine-id".text = "dcf8a7751aa94acab1e61bb6edb85ece";

  system.stateVersion = "20.03";

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
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  # mkdir -p /nfs/Cameras && chattr +i /nfs/Cameras
  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/c78289ef-b0bf-48c0-a17c-02d6f2cbed6c";
    fsType = "ext4";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Cameras    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = ''
    # # Make alias for bluetooth
    # # SUBSYSTEM=="tty", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="21e8", SYMLINK+="ttyUSB-Pluggable-Bluetooth"
  '';
}

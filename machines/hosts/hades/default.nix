{
  config,
  configName,
  clusterRole,
  lib,
  pkgs,
  ...
}:

let
  isServer = clusterRole == "server";

  kubeVipManifest = pkgs.writeText "kube-vip.yaml" ''
    apiVersion: v1
    kind: Pod
    metadata:
      name: kube-vip
      namespace: kube-system
    spec:
      containers:
      - name: kube-vip
        image: ghcr.io/kube-vip/kube-vip:v0.8.7
        imagePullPolicy: IfNotPresent
        args: ["manager"]
        env:
        - name: vip_arp
          value: "true"
        - name: port
          value: "6443"
        - name: vip_address
          value: "192.168.3.60"
        - name: vip_cidr
          value: "32"
        - name: cp_enable
          value: "true"
        - name: cp_namespace
          value: "kube-system"
        - name: svc_enable
          value: "false"
        - name: vip_leaderelection
          value: "true"
        - name: vip_leasename
          value: "plndr-cp-lock"
        - name: vip_leaseduration
          value: "5"
        - name: vip_renewdeadline
          value: "3"
        - name: vip_retryperiod
          value: "1"
        - name: prometheus_server
          value: ":2113"
        securityContext:
          capabilities:
            add: ["NET_ADMIN", "NET_RAW"]
        volumeMounts:
        - name: k3s-kubeconfig
          mountPath: /.kube/config
          readOnly: true
        - name: k3s-tls
          mountPath: /var/lib/rancher/k3s/server/tls
          readOnly: true
      hostNetwork: true
      volumes:
      - name: k3s-kubeconfig
        hostPath:
          path: /var/lib/rancher/k3s/server/cred/admin.kubeconfig
          type: File
      - name: k3s-tls
        hostPath:
          path: /var/lib/rancher/k3s/server/tls
          type: Directory
  '';

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

  # Raspberry Pi nodes run k3s/Ceph from flash/root media and have shown
  # journald EIO/rotation failures on /var/log/journal. Keep the system journal
  # in /run on those nodes to reduce write amplification and avoid a corrupt
  # persistent journal wedging logging during boot/runtime.
  #
  # Non-RPi Hades nodes keep persistent journals, capped to avoid multi-GB
  # accumulation after unclean shutdowns.
  services.journald.extraConfig =
    if isRpiHadesNode then
      ''
        Storage=volatile
        RuntimeMaxUse=128M
        RuntimeKeepFree=64M
        RateLimitIntervalSec=30s
        RateLimitBurst=1000
      ''
    else
      ''
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

  # Remove old persistent journals from the RPi nodes at boot; they are no
  # longer used with Storage=volatile and can contain corrupted system.journal
  # files from prior unclean shutdowns.
  systemd.tmpfiles.rules = lib.mkIf isRpiHadesNode [
    "R! /var/log/journal - - - -"
  ];

  # Reduce avoidable writes to the root filesystem on flash-backed RPi nodes.
  fileSystems."/".options = lib.mkIf isRpiHadesNode [
    "noatime"
    "commit=60"
    "errors=remount-ro"
  ];

  # Disable BCM43xx Bluetooth on RPi nodes — the onboard BT is unused and
  # its firmware-load timeouts (hci0: BCM: Reset failed) waste kernel resources.
  boot.blacklistedKernelModules = lib.mkIf isRpiHadesNode [
    "bluetooth"
    "btusb"
    "btbcm"
    "hci_uart"
  ];

  # boot.blacklistedKernelModules = [ "uas" ];
  # https://github.com/raspberrypi/linux/issues/5060#issuecomment-1306322303
  # https://www.reddit.com/r/NixOS/comments/znh1fm/blacklisting_in_uas_module/
  # boot.extraModprobeConfig = ''
  #   options usb-storage quirks=174c:55aa:u
  # '';

  # kube-vip control plane VIP static pod — placed on server nodes so the
  # API VIP (192.168.3.60) floats across all control-plane members.
  system.activationScripts.kube-vip = lib.mkIf isServer {
    text = ''
      mkdir -p /var/lib/rancher/k3s/agent/pod-manifests
      cp ${kubeVipManifest} /var/lib/rancher/k3s/agent/pod-manifests/kube-vip.yaml
    '';
  };
}

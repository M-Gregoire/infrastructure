{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../../dev/linux/bluetooth.nix
    ../../dev/linux/boot/grub-uefi.nix
    ./../../dev/linux/luks.nix
    ./../../dev/linux/steam.nix
    ./hardware-configuration.nix
    ./zsa.nix
  ];

  environment.etc."machine-id".text = "c4e9716cfd684ec1ad9c70b7b0dabe2a";

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  # Disable autosuspend which seems to mess with KVM switch
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  networking.wireless.enable = false;

  # Racked machine — no nextcloud personal sync needed
  systemd.user.services.nextcloud-autosync.wantedBy = lib.mkForce [];
  systemd.user.timers.nextcloud-autosync.wantedBy = lib.mkForce [];

  # Nix remote builder — use all available cores
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0;

  services.sunshine = {
    enable = true;
    openFirewall = true;
    # capSysAdmin is required for AMD DRM/KMS screen capture
    capSysAdmin = true;
    settings = {
      sunshine_name = "mimir";
      # KMS capture: GPU-level capture, sees fullscreen games, lowest latency
      # (requires capSysAdmin above)
      capture = "kms";
      # AMD hardware encoder via VA-API (VCN engine on RX 6600)
      encoder = "vaapi";
      # Enable HEVC (H.265): better quality per bit, M1 Mac decodes in hardware
      hevc_mode = 2;
      # Disable AV1 encode: RX 6600 (RDNA2) has no AV1 encode hardware
      av1_mode = 0;
      # Disable forward error correction — unnecessary overhead on wired LAN
      fec_percentage = 0;
      # Single encoding thread: lower latency on fast hardware (VAAPI does the heavy lifting)
      min_threads = 1;
    };
  };

  system.stateVersion = "20.03";
}

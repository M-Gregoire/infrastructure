# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];

  boot.initrd.availableKernelModules = [ "ahci" "e1000e" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    crypt = {
      device = "/dev/disk/by-uuid/960822f0-6772-43b0-90c2-17d9f8d11592";
      preLVM = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/mapper/nixos-root";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/nixos-home";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9D2C-ECD9";
    fsType = "vfat";
  };

  swapDevices = [{ label = "swap"; }];

  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}

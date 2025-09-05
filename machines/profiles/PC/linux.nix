{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../dev/linux/audio.nix
    ../../dev/linux/android.nix
    ../../dev/linux/binfmt.nix
    ../../dev/linux/mounting.nix
    ../../dev/linux/fwudp.nix
    ../../dev/linux/systemd-networkd.nix
    ../../dev/linux/plymouth.nix
    ../../dev/linux/printing.nix
    ../../dev/linux/ledger.nix
    ../../dev/linux/pam.nix
    ./linux-services.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";

  # Brightness control
  programs.light.enable = true;

  boot.kernelParams = [ "boot.shell_on_fail" ];

  environment.systemPackages = with pkgs; [
    # Grub theming
    # https://askubuntu.com/questions/206967/why-isnt-grub2-using-custom-resolution
    hwinfo
    # NTFS
    ntfs3g
    # exFat
    exfat
  ];

  environment.etc."wpa_supplicant.conf".source =
    "${config.resources.paths.secrets}/wpa_supplicant.conf";

  users.extraGroups.plugdev = { };
  users.users.${config.resources.username} = {
    extraGroups = [
      # go-mtfs nhoston-root mounting
      "plugdev"
      # Serial
      "dialout"
      # Disk
      "disk"
      # Audio
      "audio"
      # Brightness control
      "video"
    ];
  };

  # We need to copy the theme as root is encrypted
  #  system.activationScripts = {
  #    grub = {
  #      text = ''
  #        if [ -d "/boot/grub" ]; then
  #          mkdir -p /boot/grub/themes/Vimix
  #          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/common/* /boot/grub/themes/Vimix/
  #          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/config/theme-1080p.txt /boot/grub/themes/Vimix/theme.txt
  #          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/assets/assets-color/icons-1080p /boot/grub/themes/Vimix/icons
  #          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/assets/assets-color/select-1080p/*.png /boot/grub/themes/Vimix
  #          #cp -R ${config.resources.paths.publicConfig}/vendor/infrastructure-private/images/grub-backgrounds/background-mimir.png /boot/grub/themes/Vimix/background.png
  #          #${pkgs.gnused}/bin/sed -i 's/desktop-image: "background.jpg"/desktop-image: "background.png"/g' /boot/grub/themes/Vimix/theme.txt
  #        fi
  #      '';
  #      deps = [ ];
  #    };
  #  };

  # Get available resolutions using `videoinfo` in grub shell

  #boot.loader.grub.gfxmodeBios = "1920x1440,1280x1024,1024x768,auto";
  #boot.loader.grub.gfxmodeEfi = "1920x1440,1280x1024,1024x768,auto";
  #boot.loader.grub.gfxpayloadBios = "keep";
  #boot.loader.grub.gfxpayloadEfi = "keep";

  # Use grub theme
  # convert background.png -resize 1024x768! -depth 32 background-mimir.png
  #       set theme="($drive1)//grub/themes/Vimix/theme.txt"

  #boot.loader.grub = {
  #  extraConfig = ''
  #    set gfxmode=1920x1440,1280x1024,1024x768,auto
  #    set gfxpayload=keep
  #  '';
  #  splashImage = null;
  #};
}

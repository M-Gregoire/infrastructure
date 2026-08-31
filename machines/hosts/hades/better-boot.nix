{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      ubootRaspberryPi4_64bit = prev.ubootRaspberryPi4_64bit.overrideAttrs
        (old: {
          extraConfig = (old.extraConfig or "") + ''
            CONFIG_SYS_CONSOLE_IS_IN_ENV=y
            CONFIG_CONSOLE_MUX=y
            CONFIG_BOOTDELAY=0
            CONFIG_ZERO_BOOTDELAY_CHECK=n
          '';
          postInstall = (old.postInstall or "") + ''
            cat >> $out/u-boot.env << 'EOF'
            stdin=usbkbd
            stdout=serial,vidconsole
            stderr=serial,vidconsole
            EOF
          '';
        });
    })
  ];

  # Skip extlinux menu
  boot.loader.timeout = -1;

  # Manage config.txt declaratively
  systemd.services.rpi-config-txt = {
    description = "Update Raspberry Pi config.txt";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if grep -q "^enable_uart=1" /boot/config.txt; then
        sed -i 's/^enable_uart=1/enable_uart=0/' /boot/config.txt
      fi
    '';
  };
}

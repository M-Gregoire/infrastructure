# Use hass.io on NixOS (without AppArmor support)

- Use `automation.nix`
- Manually create the folder `/usr/sbin`
- Run `curl -sL "https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh" | bash -s` which will fail on service creation

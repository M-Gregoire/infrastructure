# Hetzner Cloud

- Create server in VPC
- Mount Nixos ISO image from console
- Reboot and boot on Nixos
- `curl -L https://gist.githubusercontent.com/M-Gregoire/54ff9109f2cab315a808a12ba9767371/raw/eae14988b652d8e9a1ff9b9fcb8a670d7515c252/hetzner-configuration.nix -o install.sh`
- `chown +x install.sh`
- `sudo bash -c ./install.sh`
- Unmount ISO and reboot

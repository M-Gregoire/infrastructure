{ pkgs, config, ... }:

{
  imports = [
    ../../dev/wireguard-client.nix
  ];

  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ pkgs.networkmanagerapplet ];
  # Network manager don't modify dns
  networking.networkmanager.dns = "none";
  networking.networkmanager.unmanaged = [ "docker0" ];
  networking.nameservers = config.resources.network.dns;
  # https://github.com/moby/moby/issues/32836
  # https://people.freedesktop.org/~lkundrak/nm-docs/NetworkManager.conf.html
  networking.networkmanager.extraConfig = ''
    [main]
    rc-manager=file
  '';

  powerManagement.resumeCommands = ''
    sleep 3 && ${pkgs.systemd}/bin/systemctl restart wireguard-wg0
  '';
}

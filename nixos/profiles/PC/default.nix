{ config, pkgs, ... }:

{
  imports = [
    (import ../../../vendor/home-manager { inherit pkgs; }).nixos
    ../../../modules
    ../../dev/3D.nix
    ../../dev/android.nix
    ../../dev/fwudp.nix
    ../../dev/ipfs.nix
    ../../dev/openvpn-client.nix
    ../../dev/pam.nix
    ../../dev/teamviewer.nix
    ../../dev/wireguard-tools.nix
    ./mime.nix
    ./services.nix
    ../../systemd-networkd.nix
  ];

  nix.nixPath = with builtins; [
    "home-manager=${toPath "/home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}" + toPath /vendor/home-manager}"
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  services.xserver.libinput = {
    # Enable libinput
    enable = true;
    # Disable acceleration
    accelProfile = "flat";
  };

  hardware.u2f.enable = true;

  users.users.${config.resources.host.username} = {
    extraGroups = [
      "networkmanager"
      # go-mtfs non-root mounting
      "plugdev"
      # Serial
      "dialout"
      # Disk
      "disk"
      # Audio
      "audio"
    ];
  };

  # Non-PC hosts
  networking.hosts = {
    "${config.resources.hosts.skuld.ip}" = [ "Skuld" ];
    "${config.resources.hosts.eldir.ip}" = [ "Eldir" ];
    "${config.resources.hosts.rind.ip}" = [ "Rind" ];
    "${config.resources.hosts.idunn.wifi.ip}" = [ "IdunnWifi" ];
    "${config.resources.hosts.idunn.eth.ip}" = [ "IdunnEth" "Idunn" ];
  };

  home-manager.users.${config.resources.host.username} = {...}: {
    imports = [
      ../../../home
      (../../../home/hosts + builtins.toPath "/${config.resources.host.name}")
    ];
    # Pass to home-manager
    nixpkgs.overlays = config.nixpkgs.overlays;
    #nixpkgs.config = config.nixpkgs.config;
    nixpkgs.config = import ../../../nixpkgs/config.nix;
    resources = config.resources;
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    # NTFS
    ntfs3g
    # exFat
    exfat
    # NFS
    nfs-utils
  ];

  networking.firewall.allowedTCPPorts = config.resources.pcs.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.pcs.openUDPPorts;
  networking.firewall.allowedTCPPortRanges = config.resources.pcs.openTCPPortsRange;
  networking.firewall.allowedUDPPortRanges = config.resources.pcs.openUDPPortsRange;

  environment.etc."wpa_supplicant.conf".source = "${config.resources.pcs.paths.privateConfig}/secrets/wpa_supplicant.conf";
}

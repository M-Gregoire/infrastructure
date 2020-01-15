{ config, pkgs, ... }:

{
  imports = [
    (import ../../../vendor/home-manager { inherit pkgs; }).nixos
    #../../dev/ipfs.nix
    ../../../modules
    ../../dev/3D.nix
    ../../dev/android.nix
    ../../dev/fwudp.nix
    ../../dev/openvpn-client.nix
    ../../dev/pam.nix
    #../../dev/teamviewer.nix
    ../../dev/wireguard-client-home.nix
    ../../dev/wireguard-tools.nix
    ./mime.nix
    ./services.nix
    ../../systemd-networkd.nix
  ];

  nix.nixPath = with builtins; [
    "home-manager=${toPath "${config.resources.pcs.paths.publicConfig}" + toPath /vendor/home-manager}"
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
      # Scanners
      "lp"
      "scanner"
    ];
  };

  # Non-PC hosts and non-localhost descriptor (MimirEth but not Mimir)
  networking.hosts = {
    "${config.resources.hosts.skuld.ip.default}" = [ "Skuld" ];
    "${config.resources.hosts.fenrir.ip.default}" = [ "Fenrir" ];
    "${config.resources.hosts.fenrirDocker.ip.default}" = [ "FenrirDocker" ];
    "${config.resources.hosts.eldir.ip.default}" = [ "Eldir" ];
    "${config.resources.hosts.idunn.ip.wifi}" = [ "IdunnWifi" (if config.resources.hosts.idunn.ip.wifi == config.resources.hosts.idunn.ip.default then "Idunn" else "") ];
    "${config.resources.hosts.idunn.ip.eth}" = [ "IdunnEth" (if config.resources.hosts.idunn.ip.eth == config.resources.hosts.idunn.ip.default then "Idunn" else "") ];
    "${config.resources.hosts.mimir.ip.wifi}" = [ "MimirWifi" (if config.resources.hosts.mimir.ip.wifi == config.resources.hosts.mimir.ip.default then "Mimir" else "") ];
    "${config.resources.hosts.mimir.ip.eth}" = [ "MimirEth" (if config.resources.hosts.mimir.ip.eth == config.resources.hosts.mimir.ip.default then "Mimir" else "") ];
  };

  home-manager.users.${config.resources.username} = {...}: {
    imports = [
      ../../../home
      (../../../home/hosts + builtins.toPath "/${config.resources.hostname}")
    ];
    # Pass to home-manager
    nixpkgs.overlays = config.nixpkgs.overlays;
    #nixpkgs.config = config.nixpkgs.config;
    nixpkgs.config = import ../../../nixpkgs/config.nix;
    resources = config.resources;
  };

  fonts.fonts = with pkgs; [
    # https://github.com/NixOS/nixpkgs/issues/47921#issuecomment-435310057
    # nix-prefetch-url --type sha256 --unpack --name source file:///home/gregoire/Downloads/nerd-fonts-2.0.0.tar.gz 09i467hyskvzj2wn5sj6shvc9pb0a0rx5iknjkkkbg1ng3bla7nm
    unstable.nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    # NTFS
    ntfs3g
    # exFat
    exfat
  ];
}

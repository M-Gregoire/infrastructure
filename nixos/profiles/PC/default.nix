{ config, pkgs, ... }:

{
  imports = [
    (import ../../../vendor/home-manager { inherit pkgs; }).nixos
    ../../../modules
    ./network.nix
    ./services.nix
    ../../dev/android.nix
    ../../dev/fwudp.nix
    ../../dev/openvpn-client.nix
    ../../dev/teamviewer.nix
    ../../dev/ipfs.nix
    ../../dev/3D.nix
    ../../dev/pam.nix
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
    "${config.resources.hosts.skuld}" = [ "Skuld" "backup.local" ];
    "${config.resources.hosts.eldir}" = [ "Eldir" ];
    "${config.resources.hosts.rind}" = [ "Rind" ];
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

  # NTFS/exFat support
  environment.systemPackages = with pkgs; [ ntfs3g exfat ];
  # KDEConnect
  networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; }];
  networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; }];

  # Firewall (TCP)
  networking.firewall.allowedTCPPorts = [
    # Key servers
    11371
  ];

  # Firewall (UDP)
  networking.firewall.allowedUDPPorts = [
    # Key servers
    11371
  ];
}

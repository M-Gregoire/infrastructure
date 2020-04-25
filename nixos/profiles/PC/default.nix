{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ../../../modules
    ../../dev/3D.nix
    ../../dev/android.nix
    ../../dev/fwudp.nix
    ../../dev/pam.nix
    ../../dev/wireguard-tools.nix
    ./mime.nix
    ./services.nix
    ../../systemd-networkd.nix
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

  services.xserver.desktopManager.session = [
    {
    name = "home-manager";
    start = ''
      ${pkgs.runtimeShell} $HOME/.hm-xsession &
      waitPID=$!
    '';
    }
  ];

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

  networking.hosts = {
    "${config.resources.hosts.eldir.ip}" = [ "Eldir" "Eldir.${config.resources.domain}"];
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
    # nix-prefetch-url --type sha256 --unpack --name source https://files.martinache.net/nerd-fonts-2.1.0.tar.gz 1la79y16k9rwcl2zsxk73c0kgdms2ma43kpjfqnq5jlbfdj0niwg
    nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    # NTFS
    ntfs3g
    # exFat
    exfat
  ];
}

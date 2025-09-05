{ config, pkgs, ... }:

{

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    # Utilities
    wget
    zip
    unzip
    # mtp mount
    jmtpfs
    # Mount remote filesystems over SSH
    sshfs
    # uptime -p
    procps
    # Yubikey
    yubico-piv-tool
    # deploy-rs
  ];
}

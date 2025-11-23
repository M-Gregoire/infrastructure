{ config, lib, pkgs, inputs, user, ... }:

let
  cephTap = builtins.fetchGit {
    url = "https://github.com/mulbc/homebrew-ceph-client";
    rev = "5243db315d7541bd7e190dbc66d1237b2c815f68";
  };
in {
  nix-homebrew = { taps = { "mulbc/homebrew-ceph-client" = cephTap; }; };
  homebrew.brews =
    [ "ceph-client" "openssh" "openvpn" "docker" "python3" "esphome" "pipx" ];
  homebrew.casks = [
    "openvpn-connect"
    "firefox"
    "thunderbird"
    "signal"
    "bitwarden"
    "calibre"
    "libreoffice"
    "multipass"
    "android-platform-tools"
  ];

  users.groups.nfs_access = {
    members = [ "${user}" ];
    gid = 1000;
  };

  system.stateVersion = 4;
}

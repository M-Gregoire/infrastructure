#!/usr/bin/env bash

sudo bash -c "cat << EOF > ~/.nix-channels
https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
https://nixos.org/channels/nixos-23.05 nixos
https://nixos.org/channels/nixos-unstable nixos-unstable
https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
EOF"

cat << EOF > ~/.nix-channels
https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
https://nixos.org/channels/nixos-23.05 nixpkgs
https://nixos.org/channels/nixos-unstable nixpkgs-unstable
EOF

nix-channel --update && sudo nix-channel --update

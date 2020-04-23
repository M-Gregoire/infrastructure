#!/usr/bin/env bash

nix-channel --add https://nixos.org/channels/nixos-20.03 nixos
nix-channel --add https://github.com/rycee/home-manager/archive/release-20.03.tar.gz home-manager
nix-channel --update

cd infrastructure-private
git fetch --all
git checkout master
git pull

cd ..

cd base16-shell
git fetch --all
git checkout master
git pull

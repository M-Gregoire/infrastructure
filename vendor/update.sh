#!/usr/bin/env bash

nix-channel --update

cd home-manager
git fetch --all
git checkout master
git pull

cd ..

cd nixpkgs-release
git remote add channels https://github.com/NixOS/nixpkgs-channels.git
git remote update channels
git fetch --all
git checkout channels/nixos-19.03

cd ..

cd infrastructure-private
git fetch --all
git checkout master
git pull

cd ..

cd base16-shell
git fetch --all
git checkout master
git pull

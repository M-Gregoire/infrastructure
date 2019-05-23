#!/usr/bin/env bash
cd home-manager
git fetch --all
git checkout master
git pull

cd ..

cd nixpkgs-unstable
git fetch --all
git remote add channels https://github.com/NixOS/nixpkgs-channels.git
git remote update channels
git checkout nixos-unstable
git pull

cd ..

cd nixpkgs-release
git fetch --all
git remote add channels https://github.com/NixOS/nixpkgs-channels.git
git remote update channels
git checkout release-19.03
git pull

cd ..

cd infrastructure-private
git fetch --all
git checkout master
git pull

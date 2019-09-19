#!/usr/bin/env bash

nixops create home.nix Bur.nix Mimir.nix Skuld.nix -d home
nixops create cloud.nix Eldir.nix -d cloud
nixops create pcs.nix Bur.nix Mimir.nix -d pcs
nixops create servers.nix Eldir.nix Skuld.nix -d servers

nixops deploy -d home
nixops deploy -d cloud
nixops deploy -d pcs
nixops deploy -d servers

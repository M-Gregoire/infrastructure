#!/usr/bin/env bash

nixops destroy -d home 2> /dev/null
nixops destroy -d cloud 2> /dev/null
nixops destroy -d pcs 2> /dev/null
nixops destroy -d servers 2> /dev/null
nixops delete -d home 2> /dev/null
nixops delete -d cloud 2> /dev/null
nixops delete -d pcs 2> /dev/null
nixops delete -d servers 2> /dev/null

nixops create home.nix Bur.nix Mimir.nix Skuld.nix Fenrir.nix -d home
nixops create cloud.nix Eldir.nix -d cloud
nixops create pcs.nix Bur.nix Mimir.nix -d pcs
nixops create servers.nix Eldir.nix Skuld.nix Fenrir.nix -d servers

#nixops deploy -d home
#nixops deploy -d cloud
#nixops deploy -d pcs
#nixops deploy -d servers

#!/usr/bin/env bash

nixops destroy -d home 2> /dev/null
nixops destroy -d cloud 2> /dev/null
nixops destroy -d pcs 2> /dev/null
nixops destroy -d servers 2> /dev/null
nixops delete -d home 2> /dev/null
nixops delete -d cloud 2> /dev/null
nixops delete -d pcs 2> /dev/null
nixops delete -d servers 2> /dev/null

nixops create home.nix vali.nix mimir.nix kvasir.nix -d home
nixops create cloud.nix eldir.nix -d cloud
nixops create pcs.nix vali.nix mimir.nix -d pcs
nixops create servers.nix eldir.nix kvasir.nix -d servers

nixops deploy -d home --create-only
nixops deploy -d cloud --create-only
nixops deploy -d pcs --create-only
nixops deploy -d servers --create-only

#!/usr/bin/env bash

nixops destroy -d deployments 2> /dev/null
nixops delete -d deployments 2> /dev/null

nixops create deployments.nix vali.nix mimir.nix kvasir.nix hades.nix eldir.nix apollon.nix -d deployments

nixops deploy -d deployments --create-only

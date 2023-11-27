#!/usr/bin/env bash

set -eou pipefail

sudo nixos-rebuild switch --flake .#"$(hostname)"
home-manager switch --flake .#"$USER"@"$(hostname)"

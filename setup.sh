#!/usr/bin/env bash

set -eou pipefail

export NIX_PATH=$(pwd)
nixos-rebuild switch --flake .#"$(hostname)" --use-remote-sudo
home-manager switch --flake .#"$USER"@"$(hostname)"

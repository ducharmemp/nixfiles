#!/usr/bin/env bash

set -eou pipefail

# Pick the right switch command for the current platform.
case "$(uname -s)" in
  Darwin)
    sudo darwin-rebuild switch --flake ".#$(scutil --get LocalHostName)"
    ;;
  Linux)
    sudo nixos-rebuild switch --flake ".#$(hostname)"
    home-manager switch --flake ".#${USER}@$(hostname)"
    ;;
esac

#!/usr/bin/env bash

shopt -s globstar
set -eou pipefail

statix check .
deadnix --fail --exclude ./secrets .
for fname in **/*.sh; do shellcheck "$fname"; done

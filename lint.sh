#!/usr/bin/env bash

shopt -s globstar
set -eou pipefail

statix check .
for fname in **/*.sh; do shellcheck "$fname"; done

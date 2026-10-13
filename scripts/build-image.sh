#!/usr/bin/env bash

image_file=$(nix build .#default --no-link --print-out-paths)

sudo docker load --input "$image_file"

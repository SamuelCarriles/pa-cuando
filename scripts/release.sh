#!/usr/bin/env bash

version="${1:? Use: release <version>}"
img_file="$(nix build .#default --no-link --print-out-paths)"

sudo docker load --input "$img_file"

local_image="pa-cuando:latest"
remote_image="ghcr.io/samuelcarriles/pa-cuando:$version"

sudo docker tag "$local_image" "$remote_image"
sudo docker push "$remote_image"

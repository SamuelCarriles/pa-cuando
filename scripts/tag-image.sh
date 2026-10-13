#!/usr/bin/env bash

version="${1:? Use: tag-image <version>}"

local_image="pa-cuando:latest"
remote_image="ghcr.io/samuelcarriles/pa-cuando:$version"

sudo docker tag "$local_image" "$remote_image"

#!/usr/bin/env bash

version="${1:? Use: push-image <version>}"

image="ghcr.io/samuelcarriles/pa-cuando:$version"

sudo docker push "$image"

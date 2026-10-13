#!/usr/bin/env bash

version="${1:? Use: push-image <version>}"

image="ghcr.io/camuelcarriles/pa-cuando:$version"

sudo docker push "$image"

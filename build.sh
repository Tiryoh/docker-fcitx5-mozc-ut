#!/bin/bash
set -eu

docker build -t ghcr.io/tiryoh/fcitx5-mozc-ut:jammy .
docker run -it --rm -v ${PWD}/dist:/ws ghcr.io/tiryoh/fcitx5-mozc-ut:jammy

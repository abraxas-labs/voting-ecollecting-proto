#! /bin/bash

set -Eeuo pipefail

docker run --rm -it --platform=linux/amd64 -v "${PWD}/../../":/data -w /data/build/angular node:16.15.1 ./build-proto.sh

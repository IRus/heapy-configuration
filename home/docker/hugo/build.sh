#!/bin/bash

set -e

HUGO_VERSION=0.82.0

docker build --progress=plain \
             --build-arg HUGO_VERSION="${HUGO_VERSION}" \
             -t hugo .

#!/bin/bash

set -e

HUGO_VERSION=0.81.0

docker build --build-arg HUGO_VERSION="${HUGO_VERSION}" -t hugo .

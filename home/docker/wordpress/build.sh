#!/bin/bash

set -e

docker build --progress=plain \
             -t "heapy/wordpress:latest" .

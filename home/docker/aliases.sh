#!/bin/bash

alias hugo="docker run --rm -it -v $(pwd):/data --network=host hugo"

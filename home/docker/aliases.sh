#!/bin/bash

alias hugo="docker run --rm -it -v $(pwd):/data --network=host hugo"
alias hugo_server="docker run --rm -it -v $(pwd):/data --network=host hugo server --disableFastRender --buildFuture --bind 0.0.0.0"

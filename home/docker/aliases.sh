#!/bin/bash

function hugo() {
    docker run --rm -it -v "$(pwd)":/data hugo "$@"
}

function hugo_server() {
    docker run --rm -it -p 1313:1313 -v "$(pwd)":/data hugo server --disableFastRender --buildFuture --bind 0.0.0.0 "$@"
}

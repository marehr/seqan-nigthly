#!/bin/bash

# Create temporary directory and set TMPDIR to this directory.  Note that the
# user can specify a TMPDIR before sourcing this script and the created
# directory will then be a subdirectory of the original TMPDIR.
mkdir -p ${TMPDIR}
_DIR=$(mktemp -d)
export TMPDIR=${DIR}

function cleanup_tmpdir()
{
    rm -rf $_DIR
}

trap cleanup_tmpdir EXIT SIGINT SIGTERM

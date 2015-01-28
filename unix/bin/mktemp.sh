#!/bin/sh

# Create temporary directory and set TMPDIR to this directory.  Note that the
# user can specify a TMPDIR before sourcing this script and the created
# directory will then be a subdirectory of the original TMPDIR.
mkdir -p ${TMPDIR}


cleanup_tmpdir()
{
    rm -rf $_DIR
}

trap cleanup_tmpdir EXIT INT TERM

#!/bin/bash

# We have to use absolute paths since we pushd out of bin.

# This is interpreted by the gcc-wrapper scripts.
#export ARCH=i686

# Set language and locale to C so we do not get UTF-8 quote marks
# that are then botched up by CDash.
export LANG=C
export LC_ALL=C

# Add flags to suppress missing OpenMP warning in nightly builds.
export CXXFLAGS="${CXXFLAGS} -DSEQAN_IGNORE_MISSING_OPENMP=1"

# Export the python path to point to the checkout.
export PYTHONPATH=/buffer/ag_abi/Nightly/seqan/linux64/co/seqan-Nightly-32/util/py_lib

# Make the software in /group/ag_abi/software/bin visible.
export PATH=/group/ag_abi/software/bin:${PATH}

# Add nightly svn wrapper to $PATH.
export PATH=/home/mi/holtgrew/Nightly/bin:${PATH}

# For 32 bit builds, we need 32 bit versions of bzlib and zlib.
export SEQAN_CMAKE_FIND_ROOT_PATH="/lib32;/usr/lib32"

# Path to LEMON library.
export LEMON_ROOT_DIR=/group/ag_abi/software/i686/lemon-1.2.3

# Path to temporary directory.
export TMPDIR=/export/userdata/holtgrew/tmp/seqan-nightly

# Enable parallel builds.
#export SEQAN_CTEST_BUILD_FLAGS="-j8"

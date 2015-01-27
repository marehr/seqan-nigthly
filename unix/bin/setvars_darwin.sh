#!/bin/sh

# Add flags to suppress missing OpenMP warning in nightly builds.
export CXXFLAGS="${CXXFLAGS} -DSEQAN_IGNORE_MISSING_OPENMP=1"

# # Export the python path to point to the checkout.
# export PYTHONPATH=$ENV{HOME}/Documents/Development/Nightly/seqan-trunk/util/py_lib

# Make the software in /group/agabi/software/bin visible.
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/cuda/bin:$PATH

## set of default compilers if not overwritten on CL
export COMPILERS=${COMPILERS-"g++-mp-4.7 g++-mp-4.8 g++-mp-4.9 clang++-mp-3.3 clang++-mp-3.4 clang++-mp-3.5 clang++-mp-3.6"}


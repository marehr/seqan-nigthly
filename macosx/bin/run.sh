#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USAGE="Usage: `basename $0` [-32] [-experimental]"
BITS=64
MODE=Nightly
mode=nightly
PLATFORM=macosx

# Parse command line options.
while getopts hvo: OPT; do
    case "$OPT" in
        h)
            echo $USAGE
            exit 0
            ;;
        32)
            BITS=32
            COMPILER_FLAGS="-m 32"
            ;;
        experimental)
            MODE=Experimental
            mode=experimental
            ;;
    esac
done


. ${DIR}/setvars_${BITS}bit.sh
mkdir -p ${DIR}/../log
pushd ${DIR}/../cmake

for COMPILER in $COMPILERS
do
  CXX="${COMPILER} ${COMPILER_FLAGS}" ctest -S seqan_${PLATFORM}_host.cmake,${MODE} -VV -d 2>&1 | tee ${DIR}/../log/ctest_${mode}_${COMPILER}-${BITS}.log
done

#CXX="clang++-trunk -std=c++0x" ctest -S seqan_${PLATFORM}_host.cmake,${MODE} -VV -d 2>&1 | tee ${DIR}/../log/ctest_${mode}_clang++-trunk-64-c++11.log
CXX="g++-mp-4.6 ${COMPILER_FLAGS}" ctest -S seqan_${PLATFORM}_host.cmake,${MODE}Coverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_${mode}_g++-4.6-${BITS}-coverage.log
CXX="g++-mp-4.6 ${COMPILER_FLAGS}" ctest -S seqan_${PLATFORM}_host.cmake,${MODE}MemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_${mode}_g++-4.6-${BITS}-memcheck.log
CXX="g++-mp-4.7 ${COMPILER_FLAGS} -std=c++11" ctest -S seqan_${PLATFORM}_host.cmake,${MODE} -VV -d 2>&1 | tee ${DIR}/../log/ctest_${mode}_g++-4.7-${BITS}-c++11.log
popd


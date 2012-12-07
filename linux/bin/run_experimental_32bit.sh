#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/setvars_32bit.sh

mkdir -p ${DIR}/../log

export SEQAN_CMAKE_FIND_ROOT_PATH="/group/agabi/software/i686/bzip-1.0.6;/group/agabi/software/i686/zlib-1.2.5"

pushd ${DIR}/../cmake
CXX="g++-4.3 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.3-32.log
CXX="g++-4.4 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.4-32.log
CXX="g++-4.5 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.5-32.log
CXX="g++-4.6 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-32.log
CXX="g++-4.7 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.7-32.log
CXX="g++-4.6.2 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-32.log
#CXX="clang++-2.9 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-2.9-32.log
CXX="clang++-3.0 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-3.0-32.log
CXX="clang++-3.1 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-3.1-32.log
CXX="clang++-trunk -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-trunk-32.log
#CXX="clang++-trunk -m32 -std=c++0x" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-trunk-32-c++11.log
CXX="g++-4.6 -m32" ctest -S seqan_linux_host_32bit.cmake,ExperimentalCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-32-coverage.log
CXX="g++-4.6 -m32" ctest -S seqan_linux_host_32bit.cmake,ExperimentalMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-32-memcheck.log
CXX="g++-4.7 -m32" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.7-32.log
CXX="g++-4.7 -m32 -std=c++11" ctest -S seqan_linux_host_32bit.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.7-32-c++11.log
popd


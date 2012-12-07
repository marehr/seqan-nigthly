#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/setvars_64bit.sh

mkdir -p ${DIR}/../log

pushd ${DIR}/../cmake
CXX="g++-4.3" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.3-64.log
CXX="g++-4.6.2" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6.24.log
CXX="g++-4.5" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.5-64.log
CXX="g++-4.6" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-64.log
CXX="g++-4.7" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.7-64.log
CXX="g++-4.7 -std=c++11" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.7-64-c++11.log
#CXX="clang++-2.9" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-2.9-64.log
CXX="clang++-3.0" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-3.0-64.log
CXX="clang++-3.1" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-3.1-64.log
CXX="clang++-trunk" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-trunk-64.log
#CXX="clang++-trunk -std=c++0x" ctest -S seqan_linux_host.cmake,Experimental -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_clang++-trunk-64-c++11.log
CXX="g++-4.6" ctest -S seqan_linux_host.cmake,ExperimentalCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-64-coverage.log
CXX="g++-4.6" ctest -S seqan_linux_host.cmake,ExperimentalMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_experimental_g++-4.6-64-memcheck.log
popd


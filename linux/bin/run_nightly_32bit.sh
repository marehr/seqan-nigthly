#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/setvars_32bit.sh

mkdir -p ${DIR}/../log

pushd ${DIR}/../cmake
#CXX="g++-4.2" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.2-32.log
#CXX="g++-4.3 -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.3-32.log
#CXX="g++-4.4 -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-32.log
#CXX="g++-4.5 -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.5-32.log
#CXX="g++-4.6 -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32.log
#CXX="clang++-2.9 -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-2.9-32.log
#CXX="clang++-trunk -m32" ctest -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-trunk-32.log
CXX="g++-4.4 -m32" ctest -S seqan_linux_host_32bit.cmake,NightlyCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-32-coverage.log
CXX="g++-4.4 -m32" ctest -S seqan_linux_host_32bit.cmake,NightlyMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-32-memcheck.log
popd

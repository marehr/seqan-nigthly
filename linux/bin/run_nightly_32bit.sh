#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CTEST=/usr/bin/ctest

. ${DIR}/setvars_32bit.sh

mkdir -p ${DIR}/../log

pushd ${DIR}/../cmake

#CXX="/usr/bin/g++-4.3 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.3-32.log
CXX="/usr/bin/g++-4.4 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-32.log
#CXX="/usr/bin/g++-4.5 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.5-32.log
CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32.log
CXX="/usr/bin/g++-4.7 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32.log

CXX="/group/ag_abi/software/bin/g++-4.8 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.8-32.log

#CXX="/group/ag_abi/software/bin/clang++-3.0 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.0-32.log
CXX="/group/ag_abi/software/bin/clang++-3.1 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.1-32.log
CXX="/group/ag_abi/software/bin/clang++-3.2 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.2-32.log
CXX="/group/ag_abi/software/bin/clang++-3.3 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.3-32.log

CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,NightlyCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32-coverage.log
CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,NightlyMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32-memcheck.log
CXX="/usr/bin/g++-4.7 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32.log
CXX="/usr/bin/g++-4.7 -m32 -std=c++11" ${CTEST} -S seqan_linux_host_32bit.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32-c++11.log

popd

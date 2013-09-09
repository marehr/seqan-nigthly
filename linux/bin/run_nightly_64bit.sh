#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CTEST=/usr/bin/ctest

. ${DIR}/setvars_64bit.sh

mkdir -p ${DIR}/../log

pushd ${DIR}/../cmake

#CXX="/usr/bin/g++-4.3" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.3-64.log
CXX="/usr/bin/g++-4.4" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-64.log
#CXX="/usr/bin/g++-4.5" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.5-64.log
CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64.log
CXX="/usr/bin/g++-4.7" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64.log

CXX="/group/ag_abi/software/bin/g++-4.8" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.8-64.log

#CXX="/group/ag_abi/software/bin/clang++-3.0" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.0-64.log
CXX="/group/ag_abi/software/bin/clang++-3.1" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.1-64.log
CXX="/group/ag_abi/software/bin/clang++-3.2" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.2-64.log
CXX="/group/ag_abi/software/bin/clang++-3.3" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.3-64.log

CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,NightlyCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64-coverage.log
CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,NightlyMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64-memcheck.log
CXX="/usr/bin/g++-4.7" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64.log
CXX="/usr/bin/g++-4.7 -std=c++11" ${CTEST} -S seqan_linux_host.cmake,Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64-c++11.log

popd


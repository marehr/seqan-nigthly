#!/bin/bash

# Add to crontab line as follows:
# 0 1 * * * GIT_BRANCH=master path/to/run_experimental_64bit.sh &>/dev/null

umask 002

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CTEST=/usr/bin/ctest

. ${DIR}/setvars_64bit.sh
. ${DIR}/lock_utils.sh
. ${DIR}/mktemp.sh

# OBTAIN LOCK OR FAIL

if exlock; then
    echo "Could not obtain lock!" 1>&2
    echo "Path to lock file is ${LOCKFILE}" 1>&2
    exit 1
fi

# ACTUALLY RUN SCRIPTS

mkdir -p /buffer/ag_abi/Nightly/seqan/linux64
mkdir -p ${DIR}/../log

pushd ${DIR}/../cmake

test -z "${GIT_BRANCH}" && GIT_BRANCH=master

#CXX="/usr/bin/g++-4.3" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.3-64.log
CXX="/usr/bin/g++-4.4" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-64.log
#CXX="/usr/bin/g++-4.5" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.5-64.log
CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64.log
CXX="/usr/bin/g++-4.7" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64.log

CXX="/group/ag_abi/software/bin/g++-4.8" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.8-64.log

#CXX="/group/ag_abi/software/bin/clang++-3.0" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.0-64.log
CXX="/group/ag_abi/software/bin/clang++-3.1" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.1-64.log
CXX="/group/ag_abi/software/bin/clang++-3.2" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.2-64.log
CXX="/group/ag_abi/software/bin/clang++-3.3" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.3-64.log

CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},NightlyCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64-coverage.log
CXX="/usr/bin/g++-4.6" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},NightlyMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-64-memcheck.log
CXX="/usr/bin/g++-4.7" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64.log
CXX="/usr/bin/g++-4.7 -std=c++11" ${CTEST} -S seqan_linux_host.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-64-c++11.log

popd
unlock

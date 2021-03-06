#!/bin/bash

# Add to crontab line as follows:
# 0 1 * * * GIT_BRANCH=master path/to/run_nightly_32bit.sh &>/dev/null

umask 002

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CTEST=/usr/bin/ctest

. ${DIR}/setvars_32bit.sh
. ${DIR}/lock_utils.sh
. ${DIR}/mktemp.sh

. ${HOME}/virtualenv/nightly/bin

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

#CXX="/usr/bin/g++-4.3 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.3-32.log
CXX="/usr/bin/g++-4.4 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.4-32.log
#CXX="/usr/bin/g++-4.5 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.5-32.log
CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32.log
CXX="/usr/bin/g++-4.7 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32.log

CXX="/group/ag_abi/software/bin/g++-4.8 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.8-32.log

#CXX="/group/ag_abi/software/bin/clang++-3.0 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.0-32.log
CXX="/group/ag_abi/software/bin/clang++-3.1 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.1-32.log
CXX="/group/ag_abi/software/bin/clang++-3.2 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.2-32.log
CXX="/group/ag_abi/software/bin/clang++-3.3 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_clang++-3.3-32.log

CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},NightlyCoverage -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32-coverage.log
CXX="/usr/bin/g++-4.6 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},NightlyMemCheck -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.6-32-memcheck.log
CXX="/usr/bin/g++-4.7 -m32" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32.log
CXX="/usr/bin/g++-4.7 -m32 -std=c++11" ${CTEST} -S seqan_linux_host_32bit.cmake,branch=${GIT_BRANCH},Nightly -VV -d 2>&1 | tee ${DIR}/../log/ctest_nightly_g++-4.7-32-c++11.log

popd
unlock

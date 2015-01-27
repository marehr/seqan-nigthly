#!/bin/sh

## written by Hannes Hauswedell and Manuel Holtgrewe

DIR="$(dirname "$0")"

export OS=$(uname | tr '[:upper:]' '[:lower:]')
export PLATFORM=$(uname)-$(uname -r)

export COMPILER_FLAGS=${COMPILER_FLAGS-""}
export GIT_BRANCH=${GIT_BRANCH-"develop"}
export HOSTBITS=$(uname -m | tail -c 3 | head -c 2) ## catches both "x86_64" and "amd64"
if [ $HOSTBITS -ne 64 ]; then
    export HOSTBITS=32
fi
export BITS=${BITS-$HOSTBITS}

# Set language and locale to C so we do not get UTF-8 quote marks
# that are then botched up by CDash.
export LANG=C
export LC_ALL=C
export LC_MESSAGES="en_EN"

## passing any argument will print debug and exit
if [ $# -gt 0 ]; then
    echo "The following environment variables can be set to influence this script:"
    echo "    BITS           32 or 64 (64 by default)"
    echo "    GIT_BRANCH     master, develop or a valid branch name (develop by default)"
    echo "    COMPILERS      list of compiler-binaries to use"
    echo "    COMPILER_FLAGS flags to append to the compiler calls"
    echo "    WITH_MEMCHECK  if set to anything CTEST will perform memchecks"
    echo "    WITH_COVERAGE  if set to anything CTEST will perform coverage checks"
    echo "    TMPDIR         place to store temporary files of run (will be pruned after"
    echo "                   run; defaults to /tmp)"
    echo "    TESTROOT        The place checkouts and builds take place (if unset defaults"
    echo "                   to TMPDIR, which means it will be pruned; otherwise it will "
    echo "                   be reused on next run)"
    echo "    THREADS       number of threads to use (defaults to 1)"
    echo ""
    exit 0;
fi

## contains operating system dependent stuff
. "${DIR}/setvars_${OS}.sh"

## set threads variable if not set on command line or local script
export THREADS=${THREADS-1}
export WITH_MEMCHECK=${WITH_MEMCHECK-0}
export WITH_COVERAGE=${WITH_COVERAGE-0}

## set dirs if not done so by user or source'd script
export TMPDIR=${TMPDIR-"/tmp"}
export TESTROOT=${TESTROOT-${TMPDIR}}

## for TMPDIR creation and cleanup
. "${DIR}/mktemp.sh"

## make sure directories exist
mkdir -p "${TMPDIR}"
mkdir -p "${TESTROOT}"
mkdir -p "${DIR}/../log"

## global log and lockfile
export METANAME="${GIT_BRANCH}_${PLATFORM}_${BITS}"
[ $WITH_MEMCHECK -ne 0 ] && export METANAME="${METANAME}_memcheck"
[ $WITH_COVERAGE -ne 0 ] && export METANAME="${METANAME}_coverage"
LOGFILE="${DIR}/../log/meta_${METANAME}.log"
LOCKFILE="${DIR}/../log/meta_${METANAME}.lock"

## Some diagnostics
echo "NIGHTLY BUILD SCRIPT FOR SEQAN"   | tee ${LOGFILE}
echo ""                                 | tee ${LOGFILE}
echo "Variables set to:"                | tee ${LOGFILE}
echo " GIT_BRANCH:     $GIT_BRANCH"     | tee ${LOGFILE}
echo " PLATFORM:       $PLATFORM"       | tee ${LOGFILE}
echo " BITS:           $BITS"           | tee ${LOGFILE}
echo " COMPILERS:      $COMPILERS"      | tee ${LOGFILE}
echo " COMPILER_FLAGS: $COMPILER_FLAGS" | tee ${LOGFILE}
echo " WITH_MEMCHECK   $WITH_MEMCHECK"  | tee ${LOGFILE}
echo " WITH_COVERAGE   $WITH_COVERAGE"  | tee ${LOGFILE}
echo ""
echo " HOSTBITS:       $HOSTBITS"       | tee ${LOGFILE}
echo " TMPDIR:         $TMPDIR"         | tee ${LOGFILE}
echo " TESTROOT:       $TESTROOT"       | tee ${LOGFILE}
echo " LOGFILE:        $LOGFILE"        | tee ${LOGFILE}
echo " LOCKFILE:       $LOCKFILE"       | tee ${LOGFILE}
echo " THREADS:        $THREADS"        | tee ${LOGFILE}
echo ""                                 | tee ${LOGFILE}

## TODO check for validity?

## for acquiring lock
. "${DIR}/lock_utils.sh"

## DEBUG
# DEBUGFILE="${DIR}/../log/$((env; date) | sha256sum | awk ' {print $1}').debug"
# date > "${DEBUGFILE}"
# env >> "${DEBUGFILE}"

cd "${DIR}/../cmake"

## OBTAIN LOCK OR FAIL
if exlock; then
    echo "Could not obtain lock!" | tee ${LOGFILE}
    echo "Path to lock file is ${LOCKFILE}" | tee ${LOGFILE}
    exit 1
fi

## RUN THE BUILDS AND TESTS
if [ "${COMPILERS}" = "" ]; then
    echo 'No $COMPILERS have been set, so nothing will be done.' | tee ${LOGFILE}
    exit 1
fi

for COMPILER in $COMPILERS
do
    # check whether $COMPILER is installed
    COMPILER_ABS=$(which "$COMPILER") # make path absolut
    if [ $? == 0 ]
    then
        echo "Running CTEST for $COMPILER " | tee ${LOGFILE}

        CCOMPILER_ABS=${COMPILER_ABS/clang++/clang}
        CCOMPILER_ABS=${CCOMPILER_ABS/g++/gcc}
        export BUILDNAME="${PLATFORM}_${COMPILER}_${BITS}"
        [ $WITH_MEMCHECK -ne 0 ] && export BUILDNAME="${BUILDNAME}_memcheck"
        [ $WITH_COVERAGE -ne 0 ] && export BUILDNAME="${BUILDNAME}_coverage"
        CTEST_LOGFILE="${DIR}/../log/ctest_${GIT_BRANCH}_${BUILDNAME}.log"

        echo " Path to CC:   $CCOMPILER_ABS" | tee ${LOGFILE}
        echo " Path to CXX:  $COMPILER_ABS"  | tee ${LOGFILE}
        echo " BUILDNAME:    $BUILDNAME"     | tee ${LOGFILE}
        echo " CTestLogfile: $CTEST_LOGFILE" | tee ${LOGFILE}
        echo " Start time:   $(date)"        | tee ${LOGFILE}

        CXX="${COMPILER_ABS} ${COMPILER_FLAGS}" CC="${CCOMPILER_ABS} ${COMPILER_FLAGS}" ctest -S seqan_unix.cmake -VV -d > ${CTEST_LOGFILE} 2>&1

        echo " Return value: $?"             | tee ${LOGFILE}
        echo " Finish time:  $(date)"        | tee ${LOGFILE}
    else
        echo "Compiler ${COMPILER} not found; skipping."
    fi
done

unlock

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
echo "NIGHTLY BUILD SCRIPT FOR SEQAN"   | tee -a ${LOGFILE}
echo ""                                 | tee -a ${LOGFILE}
echo "Variables set to:"                | tee -a ${LOGFILE}
echo " GIT_BRANCH:     $GIT_BRANCH"     | tee -a ${LOGFILE}
echo " PLATFORM:       $PLATFORM"       | tee -a ${LOGFILE}
echo " BITS:           $BITS"           | tee -a ${LOGFILE}
echo " COMPILERS:      $COMPILERS"      | tee -a ${LOGFILE}
echo " COMPILER_FLAGS: $COMPILER_FLAGS" | tee -a ${LOGFILE}
echo " WITH_MEMCHECK   $WITH_MEMCHECK"  | tee -a ${LOGFILE}
echo " WITH_COVERAGE   $WITH_COVERAGE"  | tee -a ${LOGFILE}
echo ""
echo " HOSTBITS:       $HOSTBITS"       | tee -a ${LOGFILE}
echo " TMPDIR:         $TMPDIR"         | tee -a ${LOGFILE}
echo " TESTROOT:       $TESTROOT"       | tee -a ${LOGFILE}
echo " LOGFILE:        $LOGFILE"        | tee -a ${LOGFILE}
echo " LOCKFILE:       $LOCKFILE"       | tee -a ${LOGFILE}
echo " THREADS:        $THREADS"        | tee -a ${LOGFILE}
echo ""                                 | tee -a ${LOGFILE}

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
    echo "Could not obtain lock!" | tee -a ${LOGFILE}
    echo "Path to lock file is ${LOCKFILE}" | tee -a ${LOGFILE}
    exit 1
fi

## RUN THE BUILDS AND TESTS
if [ "${COMPILERS}" = "" ]; then
    echo 'No $COMPILERS have been set, so nothing will be done.' | tee -a ${LOGFILE}
    exit 1
fi

for COMPILER in $COMPILERS
do
    # check whether $COMPILER is installed
    COMPILER_ABS=$(which "$COMPILER") # make path absolut
    if [ $? -eq 0 ]
    then
        echo "Running CTEST for $COMPILER " | tee -a ${LOGFILE}

        ## replace last occurrence of "clang++" with "clang" and "g++" with "gcc"
        CCOMPILER_ABS=$(echo $COMPILER_ABS | rev | sed -e 's|++gnalc|gnalc|' -e 's|++g|ccg|'| rev)
        export BUILDNAME="${PLATFORM}_${COMPILER}_${BITS}"
        [ $WITH_MEMCHECK -ne 0 ] && export BUILDNAME="${BUILDNAME}_memcheck"
        [ $WITH_COVERAGE -ne 0 ] && export BUILDNAME="${BUILDNAME}_coverage"
        CTEST_LOGFILE="${DIR}/../log/ctest_${GIT_BRANCH}_${BUILDNAME}.log"

        echo " Path to CC:   $CCOMPILER_ABS" | tee -a ${LOGFILE}
        echo " Path to CXX:  $COMPILER_ABS"  | tee -a ${LOGFILE}
        echo " BUILDNAME:    $BUILDNAME"     | tee -a ${LOGFILE}
        echo " CTestLogfile: $CTEST_LOGFILE" | tee -a ${LOGFILE}
        echo " Start time:   $(date)"        | tee -a ${LOGFILE}

        CXX="${COMPILER_ABS} ${COMPILER_FLAGS}" CC="${CCOMPILER_ABS} ${COMPILER_FLAGS}" ctest -S seqan_unix.cmake -VV -d > ${CTEST_LOGFILE} 2>&1

        echo " Return value: $?"             | tee -a ${LOGFILE}
        echo " Finish time:  $(date)"        | tee -a ${LOGFILE}
    else
        echo "Compiler ${COMPILER} not found; skipping."
    fi
done

unlock

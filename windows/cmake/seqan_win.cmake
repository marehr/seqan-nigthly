# Automated CTest Builds -- Workhorse File
#
# Do not define any new CTEST_* variables, prefix them with SEQAN!
#
# Variable ${CTEST_MODEL} comes from command line, this saves 1/2
# of CMake files.

CMAKE_MINIMUM_REQUIRED (VERSION 3)
cmake_policy (SET CMP0011 NEW)  # Suppress warning about PUSH/POP policy change.

# ---------------------------------------------------------------------------
# Print variables from the outside for debugging.
# ---------------------------------------------------------------------------

message (STATUS "The following variables were set from outside.")
message (STATUS "SEQAN_CTEST_HOST is      ${SEQAN_CTEST_HOST}")
message (STATUS "SEQAN_CTEST_OS is        ${SEQAN_CTEST_OS}")
message (STATUS "SEQAN_CTEST_GENERATOR is ${SEQAN_CTEST_GENERATOR}")

# ---------------------------------------------------------------------------
# Set SEQAN_CTEST_PTRWIDTH from SEQAN_CTEST_OS.
# ---------------------------------------------------------------------------

if (SEQAN_CTEST_OS MATCHES ".*32bit")
  set (SEQAN_CTEST_PTRWIDTH "32")
elseif (SEQAN_CTEST_OS MATCHES ".*64bit")
  set (SEQAN_CTEST_PTRWIDTH "64")
else (SEQAN_CTEST_OS MATCHES ".*32bit")
  message (FATAL_ERROR "No information found about number of bits in SEQAN_CTEST_OS.")
  message (FATAL_ERROR "SEQAN_CTEST_OS should look like \"Win7_32bit\", \"WinXP_64bit\"")
endif (SEQAN_CTEST_OS MATCHES ".*32bit")

message (STATUS "SEQAN_CTEST_PTRWIDTH is  ${SEQAN_CTEST_PTRWIDTH}")

# ---------------------------------------------------------------------------
# Get SEQAN_CTEST_MODEL from command args.
# ---------------------------------------------------------------------------

set (SEQAN_CTEST_MODEL Nightly)
if (${CTEST_SCRIPT_ARG} MATCHES Experimental)
    set (SEQAN_CTEST_MODEL Experimental)
elseif (${CTEST_SCRIPT_ARG} MATCHES Continuous)
    set (SEQAN_CTEST_MODEL Continuous)
endif (${CTEST_SCRIPT_ARG} MATCHES Experimental)

set (MODEL ${SEQAN_CTEST_MODEL})
message (STATUS "SEQAN_CTEST_MODEL is           ${SEQAN_CTEST_MODEL}")

# ------------------------------------------------------------
# Get git branch out of command line.
# ------------------------------------------------------------

set (SEQAN_GIT_BRANCH master)
if (${CTEST_SCRIPT_ARG} MATCHES "branch=master")
    set (SEQAN_GIT_BRANCH master)
elseif (${CTEST_SCRIPT_ARG} MATCHES "branch=develop")
    set (SEQAN_GIT_BRANCH develop)
endif ()

message (STATUS "SEQAN_GIT_BRANCH is            ${SEQAN_GIT_BRANCH}")

# ---------------------------------------------------------------------------
# Parse build type from command args, fallback to Release.
# ---------------------------------------------------------------------------

if (${CTEST_SCRIPT_ARG} MATCHES Release)
    set (CTEST_BUILD_CONFIGURATION Debug)
else ()
    set (CTEST_BUILD_CONFIGURATION Release)
endif ()

# Set CTest configuration type, lately this is necessary so app test can be
# run when built with VS (they do not correspond directly to targets).
set (CTEST_CONFIGURATION_TYPE ${CTEST_BUILD_CONFIGURATION})

# ---------------------------------------------------------------------------
# Set SEQAN_CTEST_GENERATOR_SHORT and CTEST_BUILD_NAME from the
# ${SEQAN_CTEST_*} variables.  On Unix, we use CTEST_GENERATOR_SHORT to
# store the compiler and version.
# ---------------------------------------------------------------------------

if (WIN32)
  # On Window System.

  if (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio")
    # Set ptr width into generator if 64 bit.
    if (SEQAN_CTEST_PTRWIDTH STREQUAL "64")
      set (SEQAN_CTEST_GENERATOR "${SEQAN_CTEST_GENERATOR} Win64")
    endif ()

    # Determine short generator name.
    if (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio.*")
      # SEQAN_CTEST_GENERATOR has the name schema Visual Studio 14 2015,
      # Visual Studio 12 2013, or Visual Studio 11 2012
      # Thus match the first digits, e.g. 14, 12, or 11
      STRING (REGEX REPLACE "Visual Studio ([0-9]+).+" "VS\\1" SEQAN_CTEST_GENERATOR_SHORT "${SEQAN_CTEST_GENERATOR}")
    else ()
      message (FATAL_ERROR "Unknown generator ${SEQAN_CTEST_GENERATOR}")
    endif ()
  endif ()
else ()
  message(FATAL_ERROR "Build windows sources not on windows? Srsly?")
endif ()

message (STATUS "SEQAN_CTEST_GENERATOR is ${SEQAN_CTEST_GENERATOR}")
message (STATUS "SEQAN_CTEST_GENERATOR_SHORT is ${SEQAN_CTEST_GENERATOR_SHORT}")
set (CTEST_CMAKE_GENERATOR ${SEQAN_CTEST_GENERATOR})

# ------------------------------------------------------------
# Set CTest variables with general configuration.
# ------------------------------------------------------------

# Set timeout to 2h.
set (CTEST_TIMEOUT "7200")
# Make sure the compiler generates errors and warnings in English.
set ($ENV{LC_MESSAGES} "en_EN")

# Increase reported warning and error count.
set (CTEST_CUSTOM_MAXIMUM_NUMBER_OF_ERRORS   1000)
set (CTEST_CUSTOM_MAXIMUM_NUMBER_OF_WARNINGS 1000)

# ------------------------------------------------------------
# Set CTest variables describing the build.
# ------------------------------------------------------------

set (CTEST_SITE       "${SEQAN_CTEST_HOST}")
set (CTEST_BUILD_NAME "${SEQAN_CTEST_OS}-${SEQAN_CTEST_GENERATOR_SHORT}-${SEQAN_CTEST_PTRWIDTH}")

# This project name is used for the CDash submission.
SET (CTEST_PROJECT_NAME "SeqAn")

# ------------------------------------------------------------
# Set CTest variables for directories.
# ------------------------------------------------------------

# We have one checkout per git branch since we want to do them in parallel.

# The Git checkout goes here.
set (CTEST_SOURCE_ROOT_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co-git-${SEQAN_GIT_BRANCH}/seqan-${SEQAN_CTEST_MODEL}-${SEQAN_CTEST_PTRWIDTH}")
set (CTEST_SOURCE_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co-git-${SEQAN_GIT_BRANCH}/seqan-${SEQAN_CTEST_MODEL}-${SEQAN_CTEST_PTRWIDTH}")
message (STATUS "CTEST_SOURCE_DIRECTORY = ${CTEST_SOURCE_DIRECTORY}")

# Set build directory and directory to run tests in.
set (CTEST_BINARY_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/build-git-${SEQAN_GIT_BRANCH}/${CTEST_BUILD_NAME}")
set (CTEST_BINARY_TEST_DIRECTORY "${CTEST_BINARY_DIRECTORY}")
message (STATUS "CTEST_BINARY_DIRECTORY = ${CTEST_SOURCE_DIRECTORY}")

# ------------------------------------------------------------
# Set CTest variables for programs.
# ------------------------------------------------------------

# Force language to English.
SET ($ENV{LC_MESSAGES} "en_EN")

# Give path to CMake.
set (CTEST_CMAKE_COMMAND cmake)
# Give path to git and the checkout command.
find_program (CTEST_GIT_COMMAND
              NAMES git
              HINTS "C:/Program Files (x86)/Git/bin"
                    "C:/Program Files/Git/bin")
if (NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
  set (CTEST_CHECKOUT_COMMAND "${CTEST_GIT_COMMAND} clone -b ${SEQAN_GIT_BRANCH} https://github.com/seqan/seqan.git ${CTEST_SOURCE_DIRECTORY} --recursive")
endif ()
set (CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")
message (STATUS " -- CTEST_CHECKOUT_COMMAND ${CTEST_CHECKOUT_COMMAND}")

# ------------------------------------------------------------
# Preparation of the binary directory.
# ------------------------------------------------------------

# Clear the binary directory to avoid problems.
CTEST_EMPTY_BINARY_DIRECTORY (${CTEST_BINARY_DIRECTORY})

# Write the initial cache to use for the binary tree.  Be careful to
# escape any quotes inside of this string if you use it.  This is the
# only way to communicate with the cmake process forked by ctest.
#
# Comments:
#
#   CMAKE_GENERATOR -- pass the generator
#      TODO(holtgrew): Neccesary?
#   CMAKE_BUILD_TYPE -- The build type.  We set this to Release since
#     the compiler tries its best to understand the code and unearths
#     some warning types only in this build type.
#   CMAKE_CXX_FLAGS -- C++ compiler flags.
file (WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
CMAKE_GENERATOR:INTERNAL=${CTEST_CMAKE_GENERATOR}
")

# ------------------------------------------------------------
# Suppress certain warnings.
# ------------------------------------------------------------

# Of course, the following list should be kept as short as possible and should
# be limited to very small lists of system/compiler pairs.  However, some
# warnings cannot be suppressed from the source.  Also, the warnings
# suppressed here should be specific to certain system/compiler versions.
#
# If you add anything then document what it does.

set (CTEST_CUSTOM_WARNING_EXCEPTION
    # Suppress warnings about slow 64 bit atomic intrinsics.
    "compatibility.h:.*: note:.*pragma message: slow.*64"
    "compatibility.h:.*: note:.*pragma message: slow.*64")

# ------------------------------------------------------------
# Perform the actual tests.
# ------------------------------------------------------------

message (STATUS " -- Start ctest: ${SEQAN_CTEST_MODEL} track ${SEQAN_CTEST_MODEL}-${SEQAN_GIT_BRANCH}")
CTEST_START (${SEQAN_CTEST_MODEL} TRACK "${SEQAN_CTEST_MODEL}-${SEQAN_GIT_BRANCH}")

# Copying the CTestConfig.cmake here is not optimal.  You might have to call
# ctest twice to get an actual build since ctest expects it to be present
# at the first time and will fail.
CONFIGURE_FILE (${CTEST_SOURCE_DIRECTORY}/util/cmake/CTestConfig.cmake
                ${CTEST_SOURCE_ROOT_DIRECTORY}/CTestConfig.cmake
                COPYONLY)

# Update from repository, configure, build, test, submit.  These commands will
# get all necessary information from the CTEST_* variables set above.

CTEST_UPDATE    (RETURN_VALUE VAL)
CTEST_CONFIGURE ()
CTEST_BUILD     ()
CTEST_TEST      ()
CTEST_SUBMIT    ()

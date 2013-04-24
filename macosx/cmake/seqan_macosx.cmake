
#
# Do not define any new CTEST_* variables, prefix them with SEQAN!
#
# Variable ${CTEST_MODEL} comes from command line, this saves 1/2
# of CMake files.

CMAKE_MINIMUM_REQUIRED (VERSION 2.6)
cmake_policy (SET CMP0011 NEW)  # Suppress warning about PUSH/POP policy change.

# ---------------------------------------------------------------------------
# Print variables from the outside for debugging.
# ---------------------------------------------------------------------------

message (STATUS "The following variables were set from outside.")
message (STATUS "SEQAN_CTEST_HOST is      ${SEQAN_CTEST_HOST}")
message (STATUS "SEQAN_CTEST_OS is        ${SEQAN_CTEST_OS}")
message (STATUS "SEQAN_CTEST_GENERATOR is ${SEQAN_CTEST_GENERATOR}")

# ---------------------------------------------------------------------------
# Set SEQAN_CTEST_{OS,CXX}_PTRWIDTH from SEQAN_CTEST_OS or ARCH.
# ---------------------------------------------------------------------------

if (SEQAN_CTEST_OS MATCHES ".*32bit")
  set (SEQAN_CTEST_OS_PTRWIDTH "32")
elseif (SEQAN_CTEST_OS MATCHES ".*64bit")
  set (SEQAN_CTEST_OS_PTRWIDTH "64")
else (SEQAN_CTEST_OS MATCHES ".*32bit")
  message (FATAL_ERROR "No information found about number of bits in SEQAN_CTEST_OS.")
  message (FATAL_ERROR "SEQAN_CTEST_OS should look like \"Win7_32bit\", \"WinXP_64bit\"")
endif (SEQAN_CTEST_OS MATCHES ".*32bit")

set (SEQAN_CTEST_CXX_PTRWIDTH ${SEQAN_CTEST_OS_PTRWIDTH})

if (NOT WIN32)
  if ("$ENV{CXX}" MATCHES ".* -m32.*")
    set (SEQAN_CTEST_CXX_PTRWIDTH "32")
  else ("$ENV{CXX}" MATCHES ".* -m32.*")
    set (SEQAN_CTEST_CXX_PTRWIDTH "64")
  endif ("$ENV{CXX}" MATCHES ".* -m32.*")
endif (NOT WIN32)

# The environment variable ARCH is interpreted by the compiler wrapper scripts.
if (NOT "$ENV{ARCH}x" STREQUAL "x")
  if ("$ENV{ARCH}" STREQUAL "i686")
    set (SEQAN_CTEST_CXX_PTRWIDTH "32")
  else ("$ENV{ARCH}" STREQUAL "i686")
    set (SEQAN_CTEST_CXX_PTRWIDTH "64")
  endif ("$ENV{ARCH}" STREQUAL "i686")
endif (NOT "$ENV{ARCH}x" STREQUAL "x")

message (STATUS "SEQAN_CTEST_OS_PTRWIDTH is  ${SEQAN_CTEST_OS_PTRWIDTH}")
message (STATUS "SEQAN_CTEST_CXX_PTRWIDTH is ${SEQAN_CTEST_CXX_PTRWIDTH}")

# ---------------------------------------------------------------------------
# Set SEQAN_CTEST_CXX_STANDARD_VERSION from $ENV{CXX}.
# ---------------------------------------------------------------------------

if (NOT WIN32)
  if ("$ENV{CXX}" MATCHES ".*-std=c\\+\\+11.*")
    set (SEQAN_CTEST_CXX_VERSION "c++11")
    set (SEQAN_CTEST_CXX_VERSION_STR "-c++11") # placed in compiler verison
  else ("$ENV{CXX}" MATCHES ".*-std=c\\+\\+11.*")
    set (SEQAN_CTEST_CXX_VERSION "c++98")
    set (SEQAN_CTEST_CXX_VERSION_LABEL "")  # don't show in CDash
  endif ("$ENV{CXX}" MATCHES ".*-std=c\\+\\+11.*")
endif (NOT WIN32)

# ---------------------------------------------------------------------------
# Get SEQAN_CTEST_MODEL from command args.
# ---------------------------------------------------------------------------

set (SEQAN_CTEST_MODEL Nightly)
if (${CTEST_SCRIPT_ARG} MATCHES Experimental)
    set (SEQAN_CTEST_MODEL Experimental)
elseif (${CTEST_SCRIPT_ARG} MATCHES Continuous)
    set (SEQAN_CTEST_MODEL Continuous)
elseif (${CTEST_SCRIPT_ARG} MATCHES NightlyCoverage)
    set (SEQAN_CTEST_MODEL NightlyCoverage)
elseif (${CTEST_SCRIPT_ARG} MATCHES ExperimentalCoverage)
    set (SEQAN_CTEST_MODEL ExperimentalCoverage)
elseif (${CTEST_SCRIPT_ARG} MATCHES NightlyMemCheck)
    set (SEQAN_CTEST_MODEL NightlyMemCheck)
elseif (${CTEST_SCRIPT_ARG} MATCHES ExperimentalMemCheck)
    set (SEQAN_CTEST_MODEL ExperimentalMemCheck)
endif (${CTEST_SCRIPT_ARG} MATCHES Experimental)
set (MODEL ${SEQAN_CTEST_MODEL})

message (STATUS "SEQAN_CTEST_MODEL is           ${SEQAN_CTEST_MODEL}")

# ---------------------------------------------------------------------------
# Set SEQAN_CTEST_GENERATOR_SHORT and CTEST_BUILD_NAME from the
# ${SEQAN_CTEST_*} variables.  On Unix, we use CTEST_GENERATOR_SHORT to
# store the compiler and version.
# ---------------------------------------------------------------------------

if (WIN32)
  # On Window System.

  if (SEQAN_CTEST_GENERATOR STREQUAL "MinGW Makefiles")
    set (SEQAN_CTEST_GENERATOR_SHORT "mingw")
  else (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio")
    # Set ptr width into generator if 64 bit.
    if (SEQAN_CTEST_OS_PTRWIDTH STREQUAL "64")
      set (SEQAN_CTEST_GENERATOR "${SEQAN_CTEST_GENERATOR} Win64")
    endif (SEQAN_CTEST_OS_PTRWIDTH STREQUAL "64")

    # Determine short generator name.
    if (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio 8.*")
      set (SEQAN_CTEST_GENERATOR_SHORT "VS8")
    elseif (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio 9.*")
      set (SEQAN_CTEST_GENERATOR_SHORT "VS9")
    elseif (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio 10.*")
      set (SEQAN_CTEST_GENERATOR_SHORT "VS10")
    else (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio 8.*")
      message (FATAL_ERROR "Unknown generator ${SEQAN_CTEST_GENERATOR}")
    endif (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio 8.*")
  endif (SEQAN_CTEST_GENERATOR STREQUAL "MinGW Makefiles")
else (WIN32)
  # On Unix System, the environment variable CXX has to be set.
  if ("$ENV{CXX}x" STREQUAL "x")
    message (FATAL_ERROR "Environment variable CXX not set.  Cannot determine compiler.")
  endif ("$ENV{CXX}x" STREQUAL "x")

  if ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-?.*)")
    STRING (REGEX REPLACE ".*(clang\\+\\+-?[^ ]*).*" "\\1" SEQAN_CTEST_GENERATOR_SHORT "$ENV{CXX}")
  elseif ("$ENV{CXX}" MATCHES ".*g\\+\\+-?.*")
    STRING (REGEX REPLACE ".*(g\\+\\+-?[^ ]*).*" "\\1" SEQAN_CTEST_GENERATOR_SHORT "$ENV{CXX}")
  else ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-?.*)")
    message(FATAL_ERROR "Could not determine compiler from \"$ENV{CXX}\"")
  endif ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-?.*)")
endif (WIN32)

message (STATUS "SEQAN_CTEST_GENERATOR is ${SEQAN_CTEST_GENERATOR}")
set (CTEST_CMAKE_GENERATOR ${SEQAN_CTEST_GENERATOR})

# ------------------------------------------------------------
# Set CTest variables with general configuration.
# ------------------------------------------------------------

# Set timeout to 10min.
set (CTEST_TIMEOUT "600")
# Make sure the compiler generates errors and warnings in English.
set ($ENV{LC_MESSAGES} "en_EN")

# Increase the timeout if running with memory checking.  Also, set
# SEQAN_BUILD_SUFFIX to "-memcheck".
if (MODEL STREQUAL "NightlyMemCheck")
  SET (CTEST_TEST_TIMEOUT 7200)
  SET (SEQAN_BUILD_SUFFIX "-memcheck")
elseif(MODEL STREQUAL "ExperimentalMemCheck")
  SET (CTEST_TEST_TIMEOUT 7200)
  SET (SEQAN_BUILD_SUFFIX "-memcheck")
endif (MODEL STREQUAL "NightlyMemCheck")

# Set SEQAN_BUILD_SUFFIX for Coverage tests.
if (MODEL STREQUAL "NightlyCoverage")
  SET (SEQAN_BUILD_SUFFIX "-coverage")
elseif(MODEL STREQUAL "ExperimentalCoverage")
  SET (SEQAN_BUILD_SUFFIX "-coverage")
endif (MODEL STREQUAL "NightlyCoverage")

# Increase reported warning and error count.
set (CTEST_CUSTOM_MAXIMUM_NUMBER_OF_ERRORS   1000)
set (CTEST_CUSTOM_MAXIMUM_NUMBER_OF_WARNINGS 1000)

# ------------------------------------------------------------
# Set CTest variables describing the build.
# ------------------------------------------------------------

set (CTEST_SITE       "${SEQAN_CTEST_HOST}")
set (CTEST_BUILD_NAME "${SEQAN_CTEST_OS}-${SEQAN_CTEST_GENERATOR_SHORT}-${SEQAN_CTEST_CXX_PTRWIDTH}${SEQAN_CTEST_CXX_VERSION_STR}${SEQAN_BUILD_SUFFIX}")

# This project name is used for the CDash submission.
SET (CTEST_PROJECT_NAME "SeqAn")

# ------------------------------------------------------------
# Set CTest variables for directories.
# ------------------------------------------------------------

# The SVN checkout goes here.
set (CTEST_SOURCE_ROOT_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co/seqan-${SEQAN_CTEST_MODEL}")
set (CTEST_SOURCE_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co/seqan-${SEQAN_CTEST_MODEL}")

# Set build directory and directory to run tests in.
set (CTEST_BINARY_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/build/${CTEST_BUILD_NAME}")
set (CTEST_BINARY_TEST_DIRECTORY "${CTEST_BINARY_DIRECTORY}")

# ------------------------------------------------------------
# Set CTest variables for programs.
# ------------------------------------------------------------

# Force language to English.
SET ($ENV{LC_MESSAGES} "en_EN")

# Give path to CMake.
set (CTEST_CMAKE_COMMAND cmake)
# Give path to SVN and the checkout command.
# TODO(holtgrew): The path to tortoise svn could also come from batch script.
find_program (CTEST_SVN_COMMAND
              NAMES svn
              HINTS "C:/Program Files/TortoiseSVN/bin")
set (CTEST_CHECKOUT_COMMAND "${CTEST_SVN_COMMAND} co http://svn.seqan.de/seqan/trunk ${CTEST_SOURCE_DIRECTORY}")
set (CTEST_UPDATE_COMMAND ${CTEST_SVN_COMMAND})

# ------------------------------------------------------------
# Find memcheck and coverage programs.
# ------------------------------------------------------------

FIND_PROGRAM(CTEST_MEMORYCHECK_COMMAND NAMES valgrind)
SET(CTEST_MEMORY_CHECK_COMMAND "/group/agabi/software/bin/valgrind")
SET(CTEST_MEMORYCHECK_COMMAND_OPTIONS "${CTEST_MEMORYCHECK_COMMAND_OPTIONS} --suppressions=${CTEST_SOURCE_ROOT_DIRECTORY}/misc/seqan.supp --suppressions=${CTEST_SOURCE_ROOT_DIRECTORY}/misc/python.supp")
FIND_PROGRAM(CTEST_COVERAGE_COMMAND NAMES gcov)

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

# Always write out the generator and some other settings.
file (WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_GENERATOR:INTERNAL=${CTEST_CMAKE_GENERATOR}
MEMORYCHECK_COMMAND:FILEPATH=${CTEST_MEMORYCHECK_COMMAND}
MEMORYCHECK_COMMAND_OPTIONS:STRING=--supressions=${CTEST_SOURCE_ROOT_DIRECTORY}/misc/seqan.supp
COVERAGE_COMMAND:FILEPATH=${CTEST_COVERAGE_COMMAND}
MODEL:STRING=${SEQAN_CTEST_MODEL}
CTEST_TEST_TIMEOUT:STRING=${CTEST_TEST_TIMEOUT}
CMAKE_LIBRARY_PATH:STRING=/opt/local/lib
")
# Give CMAKE_FIND_ROOT_PATH to cmake process.
if (NOT "${SEQAN_CMAKE_FIND_ROOT_PATH}x" STREQUAL "x")
  file (APPEND "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "CMAKE_FIND_ROOT_PATH:INTERNAL=${SEQAN_CMAKE_FIND_ROOT_PATH}
")
endif (NOT "${SEQAN_CMAKE_FIND_ROOT_PATH}x" STREQUAL "x")
## Give external scripts the chance to set the make command.
#if (NOT "$ENV{SEQAN_MAKE_PROGRAM}x" STREQUAL "x")
#  set (SEQAN_MAKE_PROGRAM "$ENV{SEQAN_MAKE_PROGRAM}")
#endif (NOT "$ENV{SEQAN_MAKE_PROGRAM}x" STREQUAL "x")
#if (NOT "${SEQAN_MAKE_PROGRAM}x" STREQUAL "x")
#  file (APPEND "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "CMAKE_MAKE_PROGRAM:STRING=${SEQAN_MAKE_PROGRAM}
#")
#endif (NOT "${SEQAN_MAKE_PROGRAM}x" STREQUAL "x")

# When running memory checks then generate debug symbols, otherwise compile
# in Release mode.
if (MODEL STREQUAL "NightlyMemCheck")
  file (APPEND "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_BUILD_TYPE:STRING=RelWithDebInfo")
elseif(MODEL STREQUAL "ExperimentalMemCheck")
  file (APPEND "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_BUILD_TYPE:STRING=RelWithDebInfo")
else (MODEL STREQUAL "NightlyMemCheck")
  file (APPEND "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_BUILD_TYPE:STRING=Release")
endif (MODEL STREQUAL "NightlyMemCheck")

# ------------------------------------------------------------
# Set environment variables.
# ------------------------------------------------------------

set (SEQAN_CTEST_ENVIRONMENT "")

# Copy ARCH from current environment variable such that the gcc-wrapper scripts
# pick the correct version.
if (NOT "$ENV{ARCH}x" STREQUAL "x")
  #message("set (SEQAN_CTEST_ENVIRONMENT \"ARCH=$ENV{ARCH}\" ${SEQAN_CTEST_ENVIRONMENT})")
  set (SEQAN_CTEST_ENVIRONMENT "ARCH=$ENV{ARCH}" ${SEQAN_CTEST_ENVIRONMENT})
endif (NOT "$ENV{ARCH}x" STREQUAL "x")

set (CTEST_ENVIRONMENT ${SEQAN_CTEST_ENVIRONMENT})
message("set (CTEST_ENVIRONMENT ${SEQAN_CTEST_ENVIRONMENT})")

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
    "compatibility.h:166: note:.*pragma message: slow.*64"
    "compatibility.h:304: note:.*pragma message: slow.*64"
    # Suppress unused parameter warnings inside Boost.  There is no way we can
    # influence this.
    ".*boost.*warning: unused parameter.*"
    ".*boost.*warning: no newline at end of file.*"
    ".*constants.hpp:186:61: note: expanded from.*"
    )

# ------------------------------------------------------------
# Perform the actual tests.
# ------------------------------------------------------------

## -- Start
message(" -- Start dashboard ${SEQAN_CTEST_MODEL} - ${CTEST_BUILD_NAME} --")
CTEST_START (${SEQAN_CTEST_MODEL})

# Copying the CTestConfig.cmake here is not optimal.  You might have to call
# ctest twice to get an actual build since ctest expects it to be present
# at the first time and will fail.
CONFIGURE_FILE (${CTEST_SOURCE_DIRECTORY}/util/cmake/CTestConfig.cmake
                ${CTEST_SOURCE_ROOT_DIRECTORY}/CTestConfig.cmake
                COPYONLY)

# Update from repository, configure, build, test, submit.  These commands will
# get all necessary information from the CTEST_* variables set above.
message(" -- Update ${SEQAN_CTEST_MODEL} - ${CTEST_BUILD_NAME} --")
CTEST_UPDATE    (RETURN_VALUE VAL)
CTEST_CONFIGURE ()
CTEST_BUILD     ()
CTEST_TEST      ()

# Run memory checks if configured to do so.
if (MODEL STREQUAL "NightlyMemCheck")
  CTEST_MEMCHECK (BUILD "${CTEST_BINARY_TEST_DIRECTORY}")
endif (MODEL STREQUAL "NightlyMemCheck")
if (MODEL STREQUAL "ExperimentalMemCheck")
  CTEST_MEMCHECK (BUILD "${CTEST_BINARY_TEST_DIRECTORY}")
endif (MODEL STREQUAL "ExperimentalMemCheck")
# Run coverage checks if configured to do so.
if (MODEL STREQUAL "NightlyCoverage")
  CTEST_COVERAGE(BUILD "${CTEST_BINARY_TEST_DIRECTORY}")
endif (MODEL STREQUAL "NightlyCoverage")
if (MODEL STREQUAL "ExperimentalCoverage")
  CTEST_COVERAGE(BUILD "${CTEST_BINARY_TEST_DIRECTORY}")
endif (MODEL STREQUAL "ExperimentalCoverage")

CTEST_SUBMIT    ()

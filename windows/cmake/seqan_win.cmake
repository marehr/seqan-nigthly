# Automated CTest Builds -- Workhorse File
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

if (NOT WIN32)
  if ("$ENV{CXX}" MATCHES ".* -m32")
    set (SEQAN_CTEST_PTRWIDTH "32")
  else ("$ENV{CXX}" MATCHES ".* -m32")
    set (SEQAN_CTEST_PTRWIDTH "64")
  endif ("$ENV{CXX}" MATCHES ".* -m32")
endif (NOT WIN32)

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

# ---------------------------------------------------------------------------
# Parse build type from command args, fallback to Release.
# ---------------------------------------------------------------------------

if (${CTEST_SCRIPT_ARG} MATCHES Release)
    set (CTEST_BUILD_CONFIGURATION Debug)
else (${CTEST_SCRIPT_ARG} MATCHES Release)
    set (CTEST_BUILD_CONFIGURATION Release)
endif (${CTEST_SCRIPT_ARG} MATCHES Release)

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

  if (SEQAN_CTEST_GENERATOR STREQUAL "MinGW Makefiles")
    set (SEQAN_CTEST_GENERATOR_SHORT "mingw")
  else (SEQAN_CTEST_GENERATOR MATCHES "Visual Studio")
    # Set ptr width into generator if 64 bit.
    if (SEQAN_CTEST_PTRWIDTH STREQUAL "64")
      set (SEQAN_CTEST_GENERATOR "${SEQAN_CTEST_GENERATOR} Win64")
    endif (SEQAN_CTEST_PTRWIDTH STREQUAL "64")

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

  if ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-.*)")
    STRING (REGEX REPLACE ".*(clang\\+\\+-[^ ]*).*" "\\1" SEQAN_CTEST_GENERATOR_SHORT "$ENV{CXX}")
  elseif ("$ENV{CXX}" MATCHES ".*g\\+\\+-.*")
    STRING (REGEX REPLACE ".*(g\\+\\+-[^ ]*).*" "\\1" SEQAN_CTEST_GENERATOR_SHORT "$ENV{CXX}")
  else ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-.*)")
    message(FATAL_ERROR "Could not determine compiler from \"$ENV{CXX}\"")
  endif ("$ENV{CXX}" MATCHES ".*(clang\\+\\+-.*)")
endif (WIN32)

message (STATUS "SEQAN_CTEST_GENERATOR is ${SEQAN_CTEST_GENERATOR}")
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

# The SVN checkout goes here.
set (CTEST_SOURCE_ROOT_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co/seqan-${SEQAN_CTEST_MODEL}-${SEQAN_CTEST_PTRWIDTH}")
set (CTEST_SOURCE_DIRECTORY "${SEQAN_CTEST_ROOT_DIRECTORY}/co/seqan-${SEQAN_CTEST_MODEL}-${SEQAN_CTEST_PTRWIDTH}")

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
file (WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" "
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
CMAKE_GENERATOR:INTERNAL=${CTEST_CMAKE_GENERATOR}
")

# ------------------------------------------------------------
# Perform the actual tests.
# ------------------------------------------------------------

CTEST_START (${SEQAN_CTEST_MODEL})

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

# See README.txt for the strategy used in the CMake files.
cmake_policy (SET CMP0011 NEW)  # Suppress warning about PUSH/POP policy change.

# Make GCC expect 586 processor and thus generate real atomic 4-byte operations.
SET (CTEST_CXX_FLAGS "-march=i586")

SET (SEQAN_CTEST_GENERATOR "MinGW Makefiles")
INCLUDE (seqan_win_host.cmake)

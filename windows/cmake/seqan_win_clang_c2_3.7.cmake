# See README.txt for the strategy used in the CMake files.
cmake_policy (SET CMP0011 NEW)  # Suppress warning about PUSH/POP policy change.

SET (SEQAN_CTEST_GENERATOR "Visual Studio 14 2015")
SET (SEQAN_CTEST_GENERATOR_TOOLSET "v140_clang_3_7")
INCLUDE (seqan_win_host.cmake)

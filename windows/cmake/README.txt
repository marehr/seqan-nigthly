SeqAn Automated Windows Builds CMake Files
==========================================

This directory contains the CMake files for nightly and experimental builds
on Windows.  Usually, it is located at c:\seqan-nightly\cmake.  It contains
three types of CMake files.  They are given in the order they including
each other (the first includes the second which includes the third etc.)

The variable ${MODEL} specifies whether this is a nightly or experimental
build.  The variable ${COMPILER} gives the compiler (e.g. vs10 for Visual
Studio 2010).  Internally, they are communicated through the variables
${SEQAN_CTEST_MODEL}, ${SEQAN_CTEST_GENERATOR}, and ${SEQAN_CTEST_HOST}.
The generator does not include the 32/64 bit information, this is determined
from ${SEQAN_CTEST_OS}.

  seqan_win_${MODEL}_${COMPILER}.cmake
    Set the compiler to use and include seqan_win_${MODEL}.cmake.
  
  seqan_win_${MODEL}.cmake
    Set the mode to use and include seqan_win_host.cmake.

  seqan_win_host.cmake
    Set the name of the host to use, the operating system name and include
	seqan_win.cmake.
  
  seqan_win.cmake
    Set the values from the internal variables set above into the "original"
	CMake variables and fire up the automated build and post to CDash.

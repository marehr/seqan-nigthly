@echo off
call setvars-experimental.bat

pushd c:\seqan-nightly\cmake
REM call ctest -S seqan_win_vs10.cmake,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs10.log
REM call ctest -S seqan_win_experiemntal_vs9.cmake,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs9.log
call ctest -S seqan_win_vs8.cmake,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs8.log
REM call ctest -S seqan_win_experiemntal_mingw.cmake,Experimental -VV | mtee c:\seqan-nightly\log\seqan-experimental-mingw.log
popd

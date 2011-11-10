@echo off
call setvars-experimental.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs10.cmake,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs10.log
call ctest -S seqan_win_vs9.cmake,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs9.log
call ctest -S seqan_win_vs8.cmake,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-vs8.log
call ctest -S seqan_win_mingw.cmake,Experimental -VV | mtee c:\seqan-nightly\log\seqan-experimental-mingw.log
popd

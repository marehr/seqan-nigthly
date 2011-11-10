@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs10.cmake,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-vs10.log
REM call ctest -S seqan_win_vs9.cmake,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-vs9.log
REM call ctest -S seqan_win_vs8.cmake,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-vs8.log
REM call ctest -S seqan_win_mingw.cmake,Nightly -VV | mtee c:\seqan-nightly\log\seqan-nightly-mingw.log
popd

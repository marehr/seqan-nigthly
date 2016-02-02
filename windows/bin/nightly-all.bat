@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs14.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs14.log
call ctest -S seqan_win_vs14.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs14.log
REM call ctest -S seqan_win_vs12.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs12.log
call ctest -S seqan_win_vs12.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs12.log
REM call ctest -S seqan_win_vs11.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs11.log
call ctest -S seqan_win_vs11.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs11.log
REM call ctest -S seqan_win_vs10.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs10.log
call ctest -S seqan_win_vs10.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs10.log
REM call ctest -S seqan_win_vs9.cmake,branch=develop,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs9.log
REM call ctest -S seqan_win_vs9.cmake,branch=master,Nightly    -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs9.log
REM call ctest -S seqan_win_vs8.cmake,branch=develop,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs8.log
REM call ctest -S seqan_win_vs8.cmake,branch=master,Nightly    -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs8.log
REM call ctest -S seqan_win_mingw.cmake,branch=develop,Nightly -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-mingw.log
REM call ctest -S seqan_win_mingw.cmake,branch=master,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-mingw.log
popd

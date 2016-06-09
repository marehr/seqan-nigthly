@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs14.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs14.log
call ctest -S seqan_win_vs14.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs14.log
popd

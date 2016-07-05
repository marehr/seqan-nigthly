@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_icpc_16.0.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-icpc-16.0.log
call ctest -S seqan_win_icpc_16.0.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-icpc-16.0.log
popd

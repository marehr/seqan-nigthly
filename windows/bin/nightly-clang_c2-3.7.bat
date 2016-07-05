@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_clang_c2_3.7.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-clang-c2_3.7.log
call ctest -S seqan_win_clang_c2_3.7.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-clang-c2_3.7.log
popd

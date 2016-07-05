@echo off
call setvars-nightly.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs14.cmake,branch=develop,Nightly          -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-vs14.log
call ctest -S seqan_win_icpc_16.0.cmake,branch=develop,Nightly     -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-icpc-16.0.log
call ctest -S seqan_win_clang_c2_3.7.cmake,branch=develop,Nightly  -VV | mtee c:\seqan-nightly\log\seqan-nightly-develop-clang-c2_3.7.log

call ctest -S seqan_win_vs14.cmake,branch=master,Nightly           -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-vs14.log
call ctest -S seqan_win_icpc_16.0.cmake,branch=master,Nightly      -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-icpc-16.0.log
call ctest -S seqan_win_clang_c2_3.7.cmake,branch=master,Nightly   -VV | mtee c:\seqan-nightly\log\seqan-nightly-master-clang-c2_3.7.log
popd

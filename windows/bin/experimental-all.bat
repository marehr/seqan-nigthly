@echo off
call setvars-experimental.bat

pushd c:\seqan-nightly\cmake
call ctest -S seqan_win_vs12.cmake,branch=master,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-vs12.log
call ctest -S seqan_win_vs11.cmake,branch=master,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-vs11.log
call ctest -S seqan_win_vs10.cmake,branch=master,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-vs10.log
call ctest -S seqan_win_vs9.cmake,branch=master,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-vs9.log
call ctest -S seqan_win_vs8.cmake,branch=master,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-vs8.log
call ctest -S seqan_win_mingw.cmake,branch=master,Experimental -VV | mtee c:\seqan-nightly\log\seqan-experimental-master-mingw.log

call ctest -S seqan_win_vs12.cmake,branch=develop,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-vs12.log
call ctest -S seqan_win_vs11.cmake,branch=develop,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-vs11.log
call ctest -S seqan_win_vs10.cmake,branch=develop,Experimental  -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-vs10.log
call ctest -S seqan_win_vs9.cmake,branch=develop,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-vs9.log
call ctest -S seqan_win_vs8.cmake,branch=develop,Experimental   -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-vs8.log
call ctest -S seqan_win_mingw.cmake,branch=develop,Experimental -VV | mtee c:\seqan-nightly\log\seqan-experimental-develop-mingw.log
popd

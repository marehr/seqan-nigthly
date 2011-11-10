SeqAn Automated Windows Builds
==============================

This directory is home of the windows builds.  It is usually located at
c:\seqan-nightly.

Contents

  bin
    This directory contains Batch files for running all and specific nightly
	and experimental builds.  Furthermore, the program mtee.exe is a Windows
	port of Unix tee.
  
  cmake
    The cmake files are here.  More information about the structure can be
	found in cmake/README.txt
  
  log
	Log files go here.  Files are named seqan-${MODEL}-${SHORT GENERATOR}.log

  co
	Checkouts go here.  The directories are named seqan-${MODEL}.
  
  build
    The builds go here into directories called ${HOST}-${SHORT GENERATOR}.
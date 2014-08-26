#!/bin/bash

## Copyright (C) 2009  Przemyslaw Pawelczyk <przemoc@gmail.com>
## License: GNU General Public License v2, v3
#
# Lockable script boilerplate

### HEADER ###

LOCKFILE="/var/lock/`basename $0`"

# PRIVATE
_lock()             { echo "LOCKING"; ! lockfile -r 0 ${LOCKFILE}; }
_no_more_locking()  { echo "UNLOCKING"; rm -f $LOCKFILE; }
_prepare_locking()  { trap _no_more_locking EXIT TERM INT KILL QUIT HUP SEGV PIPE; }

# ON START
_prepare_locking

# PUBLIC
exlock()        { _lock; }  # obtain an exclusive lock immediately or fail
unlock()        { _no_more_locking; }   # drop a lock

# Remember! Lock file is removed when one of the scripts exits and it is
#           the only script holding the lock or lock is not acquired at all.

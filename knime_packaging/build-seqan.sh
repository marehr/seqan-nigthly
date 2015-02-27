#!/bin/bash

umask 002

SCRIPT_PATH=`dirname $0`

# load path options
source ${SCRIPT_PATH}/config.sh
source ${SCRIPT_PATH}/functions.sh

# update seqan
git_update $SEQAN_SOURCE master

# clear old plugin sources
rm -r $PLUGIN_SOURCE
mkdir -p $PLUGIN_SOURCE

# configure seqan
mkdir -p $SEQAN_BUILD
cd $SEQAN_BUILD
cmake -D WORKFLOW_PLUGIN_DIR=$PLUGIN_SOURCE -D CMAKE_BUILD_TYPE=Release $SEQAN_SOURCE

# build seqan
##cmake --build . --target prepare_workflow_plugin --config Release
# we use make directly to keep going in case of errors
make prepare_workflow_plugin -k

# ensure plugin central exists
ssh $PLUGIN_CENTRAL_HOST "mkdir -p ${PLUGIN_CENTRAL_PATH}"

# copy to central assembly location
rsync -avz $PLUGIN_SOURCE/ $PLUGIN_CENTRAL/

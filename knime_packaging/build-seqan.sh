#!/bin/bash

# load path options
source config.sh
source functions.sh

# update seqan 
git_update $SEQAN_SOURCE master

# clear old plugin sources
rm -r $PLUGIN_SOURCE/*

# configure seqan
cd $SEQAN_BUILD
cmake -D WORKFLOW_PLUGIN_DIR=$PLUGIN_SOURCE -D CMAKE_BUILD_TYPE=Release $SEQAN_SOURCE

# build seqan
cmake --build . --target prepare_workflow_plugin --config Release

# copy to central assembly location
rsync -avz $PLUGIN_SOURCE/ $PLUGIN_CENTRAL/
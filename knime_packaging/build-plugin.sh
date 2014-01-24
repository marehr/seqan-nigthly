#!/bin/bash

# load path options
source config.sh
source functions.sh

# build the plugin source code
pushd ${BASE_PLUGIN_PATH}

mkdir -p ${PLUGIN_BUILD}

ant -Dplugin.dir=${PLUGIN_CENTRAL_PATH} -Dcustom.plugin.generator.target=${PLUGIN_BUILD} -Dknime.sdk=${KNIME_SDK}

popd

# copy to final, remote-accessible target
rsync -avzn --delete --exclude ".git" ${PLUGIN_BUILD}/ ${REMOTE_TARGET}

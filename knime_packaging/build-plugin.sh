#!/bin/bash

# load path options
source config.sh
source functions.sh

# build the plugin source code
pushd ${BASE_PLUGIN_PATH}

ant -Dplugin.dir=${PLUGIN_SOURCE} -Dcustom.plugin.generator.target=${PLUGIN_BUILD} -Dknime.sdk=${KNIME_SDK}

popd

# copy to final, remote-accessible target
rsync -avz --delete --exclude ".git" ${PLUGIN_BUILD}/ ${TARGET}

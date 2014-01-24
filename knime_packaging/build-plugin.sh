#!/bin/bash

SCRIPT_PATH=`dirname $0`

# load path options
source ${SCRIPT_PATH}/config.sh
source ${SCRIPT_PATH}/functions.sh

# fetch updates for node generator
git_update ${BASE_PLUGIN_PATH} develop

# build the plugin source code
pushd ${BASE_PLUGIN_PATH}

mkdir -p ${PLUGIN_BUILD}

ant -Dplugin.dir=${PLUGIN_CENTRAL_PATH} -Dcustom.plugin.generator.target=${PLUGIN_BUILD} -Dknime.sdk=${KNIME_SDK}

popd

# copy to final, remote-accessible target
rsync -avz --delete --exclude ".git" ${PLUGIN_BUILD}/ ${REMOTE_TARGET}

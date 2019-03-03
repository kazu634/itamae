#!/bin/bash

set -e

DIR=$(mktemp -d)
DATE=$(date "+%Y%m%d")

mongodump -v --out "${DIR}" -h <%= @ipaddr %>

tar cvzf "/tmp/wekan-mongodb-bk-${DATE}.tgz" "${DIR}"

rm -rf "${DIR}"

exit 0

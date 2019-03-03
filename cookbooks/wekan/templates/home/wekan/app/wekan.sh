#!/bin/bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PORT=3000
export ROOT_URL="https://wekan.kazu634.com"
export MONGO_URL="mongodb://<%= @ipaddr %>:27017/wekan"

/home/wekan/.nvm/versions/node/<%= @node_ver %>/bin/node /home/wekan/app/wekan/bundle/main.js

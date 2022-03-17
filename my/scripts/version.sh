#!/bin/bash
export APP_NAME="Dockovpn"
export APP_INSTALL_PATH =/opt/$APP_NAME
export APP_PERSIST_DIR=/opt/$APP_NAME_data
source ./functions.sh

APP_VERSION="$(cat $APP_INSTALL_PATH/config/VERSION)"

echo "$(datef) $APP_NAME $APP_VERSION"
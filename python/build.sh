#!/bin/bash

bash_major="${BASH_VERSINFO[0]}"
bash_minor="${BASH_VERSINFO[1]}"

if (( bash_major < 4 )); then
    echo "ERROR: Bash version $BASH_VERSION is too old. Required: 4.0 or higher" >&2
    exit 1
fi

THIS_DIR=$(cd $(dirname ${BASH_SOURCE}) && pwd)

set -e

# Expected environment example:
#   SO_APP_NAME=app-by-shell
#   SO_APP_VERSION=0.1.0
# Custom environment:
#   APP_CUSTOM_ARG=

echo "Starting script $0 (Bash $bash_major.$bash_minor) $@"
echo "SO_APP_NAME=${SO_APP_NAME}"
echo "SO_APP_VERSION=${SO_APP_VERSION}"
echo "Custom environment:"
echo "APP_CUSTOM_ARG=${APP_CUSTOM_ARG}"

FORCE_SET_APP_VERSION=false
for arg in "$@"; do
    if [ "$arg" = "force_set_version" ]; then
        FORCE_SET_APP_VERSION=true
        break
    fi
done

DOCKERFILE=Dockerfile

APP_INFO_FILE="${THIS_DIR}/py_app/app_info.py"
if [ ! -f ${APP_INFO_FILE} ]; then
    echo "${APP_INFO_FILE} was not found!" >&2
    exit 1
fi

APP_VERSION=$(grep -oP '__appversion__="\K[^"]*' "$APP_INFO_FILE")

if [ -n "${SO_APP_VERSION}" ]; then
    if [ ${SO_APP_VERSION} != "latest" ]; then
        if [[ "$FORCE_SET_APP_VERSION" = false && ${SO_APP_VERSION} != ${APP_VERSION} ]]; then
            echo "Invalid application version!" >&2
            echo "Current version from sources is ${APP_VERSION}, but ${SO_APP_VERSION} is expected." >&2
            echo "Is a valid source code commit selected?" >&2
            exit 1
        fi
    fi

    APP_VERSION=${SO_APP_VERSION}
fi

if [ -z ${SO_APP_NAME} ]; then
    APP_NAME=$(grep -oP '__appname__="\K[^"]*' "$APP_INFO_FILE")
    # Convert to lowercase to be used as tag
    APP_NAME="${APP_NAME,,}"
else
    APP_NAME=${SO_APP_NAME}
fi

APP_RESPONSE='Built with Shell'
if [ -n "${APP_CUSTOM_ARG}" ]; then
    APP_RESPONSE="${APP_RESPONSE} (${APP_CUSTOM_ARG})"
fi

pushd ${THIS_DIR} >/dev/null
docker build -t ${APP_NAME}:${APP_VERSION} --build-arg APP_RESPONSE="${APP_RESPONSE}" -f ${DOCKERFILE} .
popd >/dev/null
